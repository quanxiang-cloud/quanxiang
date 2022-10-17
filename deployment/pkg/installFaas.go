package pkg

import (
	"encoding/base64"
	"errors"
	"fmt"
	"os"
	"strings"

	"gopkg.in/yaml.v2"
)

type SecretSSH struct {
	Kind       string   `yaml:"kind"`       // Secret
	ApiVersion string   `yaml:"apiVersion"` // v1
	Data       SSHData  `yaml:"data"`
	Meta       MetaData `yaml:"metadata"`
	Type       string   `yaml:"type"` //kubernetes.io/ssh-auth
}

type SSHAnnota struct {
	Token string `yaml:"tekton.dev/git-0"` // 'http://192.168.208.51:8080'
}
type MetaData struct {
	Name        string    `yaml:"name" json:"name,omitempty"`            // rsa
	NameSpace   string    `yaml:"namespace" json:"name_space,omitempty"` //builder
	Annotations SSHAnnota `yaml:"annotations" json:"annotations,omitempty"`
}
type SSHData struct {
	KnownHosts    string `yaml:"known_hosts"`    //使用 ssh-keyscan -p 22端口 gitlab域名或者ip |base64 -w 0 生成
	SSHPrivatekey string `yaml:"ssh-privatekey"` //ssh-keygen -t rsa -f git_rsa -C "admin@quanxiang.dev" 生成ssh key, 将私钥使用base64编码, cat git_rsa|base64 -w 0
}

func InitFaas(kubeconfig, namespace, depPath string, configs *Configs) error {
	sqlFile := "./initfaas.sql"
	knowHosts := fmt.Sprintf("ssh://git@%s:%d/", configs.Faas.Git.GitSSHAddress, configs.Faas.Git.GitSSHPort)
	knowHostsScan := fmt.Sprintf("ssh://%s:%d/", configs.Faas.Git.GitSSHAddress, configs.Faas.Git.GitSSHPort)
	sshKey := DecodeBase64String(configs.Faas.Git.SSHPrivatekey)
	if sshKey == "" {
		return errors.New("decoder ssh failed")
	}
	gitSql := fmt.Sprintf("insert into gits (id, host, token, name, known_hosts, key_scan_known_hosts, ssh) values('%s', '%s','%s', '%s','%s', '%s', '%s');",
		"mzHjx1QR", configs.Faas.Git.Host, configs.Faas.Git.Token, "rsa", knowHosts, knowHostsScan, string(sshKey))
	dockerSql := fmt.Sprintf("insert into dockers (id, host, user_name, name_space, secret, name) values('aZhvb2qR', '%s', '%s', '%s', '%s', '%s');",
		configs.Faas.Docker.Host, configs.Faas.Docker.User, configs.Faas.Docker.NameSpace, configs.Faas.Docker.Pass, "faas-docker")
	dbUse := "USE faas;\n"
	_, err := os.Stat(sqlFile)
	if err == nil {
		_ = os.Remove(sqlFile)
	}
	f, err := os.OpenFile(sqlFile, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		return err
	}
	defer f.Close()
	str := fmt.Sprintf("%s\n%s\n%s\n", dbUse, gitSql, dockerSql)
	_, err = f.Write([]byte(str))
	if err != nil {
		return err
	}
	err = deployMysql(kubeconfig, namespace, "./initfaas.sql", depPath, configs)
	if err != nil {
		return err
	}
	return err
}

func applyGitSecret(host, known_hosts, ssh, kubeconfig, namespace string) error {
	var sshSecret SecretSSH
	yamlFile := "./secret.yaml"

	sshSecret.ApiVersion = "v1"
	sshSecret.Kind = "Secret"
	sshSecret.Type = "kubernetes.io/ssh-auth"
	sshSecret.Data.KnownHosts = known_hosts
	sshSecret.Meta.Annotations.Token = host
	sshSecret.Meta.Name = "rsa"
	sshSecret.Meta.NameSpace = namespace
	sshSecret.Data.SSHPrivatekey = ssh

	sshBytes, err := yaml.Marshal(&sshSecret)
	if err != nil {
		fmt.Println(err)
		return err
	}
	_, err = os.Stat(yamlFile)
	if err == nil {
		_ = os.Remove(yamlFile)
	}
	f, err := os.OpenFile(yamlFile, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		return err
	}
	defer f.Close()
	_, err = f.Write(sshBytes)
	if err != nil {
		fmt.Println(err)
		return err
	}
	command := fmt.Sprintf("kubectl apply -f %s --kubeconfig %s", yamlFile, kubeconfig)
	err = execBash(command)
	if err != nil {
		return err
	}
	return err
}

func applyHarbor(username, password, server, kubeconfig string) error {
	command := "kubectl create secret docker-registry faas-docker --docker-username=" + username + " --docker-password=" + password + " --docker-server=" + server + " -n builder" + " --kubeconfig " + kubeconfig
	err := execBash(command)
	if err != nil {
		return err
	}
	command = "kubectl create secret docker-registry faas-docker --docker-username=" + username + " --docker-password=" + password + " --docker-server=" + server + " -n serving" + " --kubeconfig " + kubeconfig
	err = execBash(command)
	if err != nil {
		return err
	}
	return nil
}

func DecodeBase64String(enc string) string {
	reader := strings.NewReader(enc)
	decoder := base64.NewDecoder(base64.RawStdEncoding, reader)
	buf := make([]byte, 1024)
	dst := ""
	for {
		n, err := decoder.Read(buf)
		dst += string(buf[:n])
		if err != nil || n == 0 {
			break
		}
	}
	return dst
}
