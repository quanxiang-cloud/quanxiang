package pkg

import (
	"context"
	"errors"
	"fmt"
	"path/filepath"

	_ "github.com/go-sql-driver/mysql"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	ctrl "sigs.k8s.io/controller-runtime"
)

type Gits struct {
	ID         string `gorm:"column:id;type:varchar(64);PRIMARY_KEY" json:"id"`
	Host       string `gorm:"column:host;type:varchar(200);" json:"host"`
	KnownHosts string `gorm:"column:known_hosts;type:text;" json:"knownHosts"`
	SSH        string `gorm:"column:ssh;type:text;" json:"ssh"`
	Token      string `gorm:"column:token;type:text;" json:"token"`
	Name       string `gorm:"column:name;type:varchar(200);" json:"name"`

	CreatedAt int64  `gorm:"column:created_at;type:bigint; " json:"createdAt,omitempty" `
	UpdatedAt int64  `gorm:"column:updated_at;type:bigint; " json:"updatedAt,omitempty" `
	DeletedAt int64  `gorm:"column:deleted_at;type:bigint; " json:"deletedAt,omitempty" `
	CreatedBy string `gorm:"column:created_by;type:varchar(64); " json:"createdBy,omitempty"` //创建者
	UpdatedBy string `gorm:"column:updated_by;type:varchar(64); " json:"updatedBy,omitempty"` //创建者
	DeletedBy string `gorm:"column:deleted_by;type:varchar(64); " json:"deletedBy,omitempty"` //删除者
	TenantID  string `gorm:"column:tenant_id;type:varchar(64); " json:"tenantID"`             //租户id
}
type Dockers struct {
	ID        string `gorm:"column:id;type:varchar(64);PRIMARY_KEY" json:"id"`
	Host      string `gorm:"column:host;type:varchar(200);" json:"host"`
	UserName  string `gorm:"column:user_name;type:varchar(64);" json:"userName"`
	NameSpace string `gorm:"column:name_space;type:varchar(64);" json:"nameSpace"`
	Secret    string `gorm:"column:secret;type:text;" json:"secret"`
	Name      string `gorm:"column:name;type:varchar(64);" json:"name"`

	CreatedAt int64  `gorm:"column:created_at;type:bigint; " json:"createdAt,omitempty" `
	UpdatedAt int64  `gorm:"column:updated_at;type:bigint; " json:"updatedAt,omitempty" `
	DeletedAt int64  `gorm:"column:deleted_at;type:bigint; " json:"deletedAt,omitempty" `
	CreatedBy string `gorm:"column:created_by;type:varchar(64); " json:"createdBy,omitempty"` //创建者
	UpdatedBy string `gorm:"column:updated_by;type:varchar(64); " json:"updatedBy,omitempty"` //创建者
	DeletedBy string `gorm:"column:deleted_by;type:varchar(64); " json:"deletedBy,omitempty"` //删除者
	TenantID  string `gorm:"column:tenant_id;type:varchar(64); " json:"tenantID"`             //租户id
}

func applyGitSeret(host, know_host, ssh, kubeconfig, namespace string) error {
	if kubeconfig == "" || kubeconfig == "~/.kube/config" {
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		} else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return errors.New("NO_KUBECONFIG")
		}
	}
	config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}
	secret := clientset.CoreV1().Secrets(namespace)
	data := make(map[string][]byte)
	// ssh-keyscan github.com | base64
	data["known_hosts"] = []byte(know_host)
	data["ssh-privatekey"] = []byte(ssh)

	tekton := make(map[string]string)
	tekton["tekton.dev/git-0"] = host

	s := &v1.Secret{
		Type: v1.SecretTypeSSHAuth,
		ObjectMeta: ctrl.ObjectMeta{
			Name:        "rsa",
			Namespace:   namespace,
			Annotations: tekton,
		},
		Data: data,
	}
	options := metav1.CreateOptions{}
	_, err = secret.Create(context.Background(), s, options)
	if err != nil {
		return err
	}
	return err
}

func applyHarbor(username, password, server string) error {
	command := "kubectl create secret docker-registry faas-harbor --docker-username=" + username + " --docker-password=" + password + " --docker-server=" + server + " -n builder"
	err := execBash(command)
	if err != nil {
		return err
	}
	command = "kubectl create secret docker-registry faas-harbor --docker-username=" + username + " --docker-password=" + password + " --docker-server=" + server + " -n serving"
	err = execBash(command)
	if err != nil {
		return err
	}
	return nil
}

/*
func applyFaasSql(msserver,msport,username,password,token,git_host,knows_hosts,ssh,docker_host,docker_username,docker_pass string) error {
	gits := Gits{}
	gits.ID="J2P57lAS"
	gits.Host = git_host
	gits.Token = token
	gits.KnownHosts = knows_hosts
	gits.Name = "rsa"
	gits.SSH = ssh
	fqn := username+ ":" + password+"@tcp("+msserver+":"+msport+")/faas?charset=utf8&parseTime=True&loc=Local"
	db, err := gorm.Open("mysql", fqn)
	if err != nil {
		return err
	}
	defer db.Close()
	db.Create(&gits)
	docker := Dockers{}
	docker.ID = "1"
	docker.Host = docker_host
	docker.Name = "faas-harbor"
	docker.UserName = docker_username
	docker.Secret = docker_pass
	db.Create(&docker)
	return nil
}
*/
