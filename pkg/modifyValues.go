/*
Copyright 2020 QuanxiangCloud Authors
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package pkg

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"strings"
	"text/template"

	uuid "github.com/satori/go.uuid"
	"gopkg.in/yaml.v2"
)

//project
type values struct {
	Image struct {
		Name string `yaml:"name"`
		Repo string `yaml:"repo"`
		Tag  string `yaml:"tag"`
	}
	Namespace  string `yaml:"namespace"`
	Domain     string `yaml:"domain"`
	Mongo_host string `yaml:"mongo_host"`
	Args       struct {
		Enabled  bool   `yaml:"enabled"`
		Endpoint string `yaml:"endpoint"`
		Ip       string `yaml:"ip"`
	}
	Kafka struct {
		Value string `yaml:"value"`
	}
	Redis struct {
		Host     string `yaml:"host"`
		Password string `yaml:"password"`
	}
	ImagePullSecrets string `yaml:"imagePullSecrets"`
	Service          struct {
		Type    string `yaml:"type"`
		Port    int    `yaml:"port"`
		RpcPort int    `yaml:"rpcPort"`
	}
	NameOverride       string `yaml:"nameOverride"`
	FullnameOverride   string `yaml:"fullnameOverride"`
	Websocket_hostname string `yaml:"websocket_hostname"`
	Home_hostname      string `yaml:"home_hostname"`
	Portal_hostname    string `yaml:"portal_hostname"`
	Vendor             Vendor `yaml:"vendor"`
	ServiceAccount     struct {
		Create bool   `yaml:"create"`
		Name   string `yaml:"name"`
	} `yaml:"serviceAccount"`
	ClusterRole        ClusterRole            `json:"clusterRole"`
	PodSecurityContext map[string]interface{} `yaml:"podSecurityContext"`
	SecurityContext    map[string]interface{} `yaml:"securityContext"`
	Config             struct {
		JwtKey  string `yaml:"jwtKey"`
		Mysql   Mysql
		Redis   Redis
		Elastic Elastic
		Kafka   Kafka
		Mongo   Mongo
		Etcd    Etcd
		Storage Storage
		Email   Email
	}
	Ingress struct {
		Enabled bool `yaml:"enabled"`
		Hosts   []struct {
			Host string `yaml:"host"`
			//Paths []struct{
			//	Path string `yaml: path`
			//	FullName string `yaml: fullName`
			//	SvcPort int `yaml svcPort`
			//}`yaml: paths`
			Paths []map[string]interface{} `yaml:"paths"`
		} `yaml:"hosts"`
	}
	App struct {
		Kubernetes struct {
			Io struct {
				Name string `yaml:"name"`
			} `yaml:"io"`
		} `yaml:"kubernetes"`
	}
}

type Vendor struct {
	Protocol string `yaml:"protocol"`
	Hostname string `yaml:"hostname"`
	Port     int    `yaml:"port"`
}

type Annotations struct {
	RbacAuthorizationKubernetesIoAutoupdate string `json:"rbac.authorization.kubernetes.io/autoupdate"`
}
type ClusterRole struct {
	Create      bool        `json:"create"`
	Name        string      `json:"name"`
	Annotations Annotations `json:"annotations"`
}

//func ReadAllValuesFile(configFile string) (*values,error) {
//	all := new(values)
//	data,err := ioutil.ReadFile(configFile)
//	if err != nil {
//		fmt.Println("读取value文件失败")
//		return nil,err
//	}
//	err = yaml.Unmarshal(data,all)
//	if err != nil {
//		return nil,err
//	}
//	return all,nil
//}
func ModifyValuesFile(filepath, namespace string, configs *Configs, ngGateWay bool) error {
	//all,err := ReadAllValuesFile(configFile)
	//if err != nil {
	//	return err
	//}
	value := new(values)
	data, err := ioutil.ReadFile(filepath)
	if err != nil {
		fmt.Println("读取value文件失败")
		return err
	}
	err = yaml.Unmarshal(data, value)
	if err != nil {
		fmt.Println("读取数据失败")
		return err
	}
	if configs.Mysql.Enabled {
		value.Config.Mysql.Host, err = AddrParase(configs.Config.Mysql.Host, namespace)
		if err != nil {
			return err
		}
		value.Config.Mysql.Password = configs.Config.Mysql.Password
		value.Config.Mysql.User = configs.Config.Mysql.User
		value.Config.Mysql.Log = configs.Config.Mysql.Log
	} else {
		value.Config.Mysql.Host = configs.Config.Mysql.Host
		value.Config.Mysql.Password = configs.Config.Mysql.Password
		value.Config.Mysql.User = configs.Config.Mysql.User
		value.Config.Mysql.Log = configs.Config.Mysql.Log
	}
	//value.Config.Redis = configs.Config.Redis
	if strings.Contains(filepath, "flow") {
		value.Redis.Host = ""
		for _, v := range value.Config.Redis.Addrs {
			value.Redis.Host += v
			value.Redis.Host += ","
		}
		value.Redis.Host = strings.TrimSuffix(value.Redis.Host, ",")
		value.Redis.Password = configs.Config.Redis.Password
	}
	if configs.Redis.Enabled {
		for i, v := range value.Config.Redis.Addrs {
			value.Config.Redis.Addrs[i], err = AddrParase(v, namespace)
			if err != nil {
				return err
			}
		}
		value.Config.Redis.Username = configs.Config.Redis.Username
		value.Config.Redis.Password = configs.Config.Redis.Password
	} else {
		value.Config.Redis = configs.Config.Redis
	}
	if configs.Elastic.Enabled {
		ev, _ := AddrParase(configs.Config.Elastic.Host[0], namespace)
		elas_v := []string{ev}
		value.Config.Elastic.Host = elas_v
		value.Config.Elastic.Log = configs.Config.Elastic.Log
	} else {
		value.Config.Elastic = configs.Config.Elastic
	}
	if configs.Mongo.Enabled {
		mongoHost, err := AddrParase(configs.Config.Mongo.Hosts[0], namespace)
		if err != nil {
			fmt.Println(err)
		}
		if len(value.Config.Mongo.Hosts) == 0 {
			value.Config.Mongo.Hosts = append(value.Config.Mongo.Hosts, mongoHost)
		}
		value.Config.Mongo.Hosts[0] = mongoHost

		value.Config.Mongo.Credential = configs.Config.Mongo.Credential
		value.Config.Mongo.Direct = configs.Config.Mongo.Direct
	} else {
		value.Config.Mongo = configs.Config.Mongo
	}
	/*
		if configs.Etcd.Enabled {
			value.Config.Etcd.Addrs[0], err = AddrParase(configs.Config.Etcd.Addrs[0], namespace)
			if err != nil {
				fmt.Println(err)
			}
			for i, _ := range value.Config.Etcd.Addrs {
				if i == 0 {
					continue
				} else {
					value.Config.Etcd.Addrs[i] = ""
				}
			}
			value.Config.Etcd.Username = configs.Config.Etcd.Username
			value.Config.Etcd.Password = configs.Config.Etcd.Password
		} else {
			value.Config.Etcd.Addrs = configs.Config.Etcd.Addrs
			value.Config.Etcd.Username = configs.Config.Etcd.Username
			value.Config.Etcd.Password = configs.Config.Etcd.Password
		}
		if strings.Contains(filepath, "portal") {
			value.Ingress.Hosts[0].Host = "portal." + configs.Domain
			value.Websocket_hostname = "ws." + configs.Domain
			value.Home_hostname = "home." + configs.Domain
			value.Portal_hostname = "portal." + configs.Domain
			value.Vendor.Hostname = "vendors." + configs.Domain
			value.Vendor.Port = 80
			value.Vendor.Protocol = "http"
		}
	*/
	if strings.Contains(filepath, "home") {
		value.Ingress.Hosts[0].Host = "home." + configs.Domain
		value.Websocket_hostname = "ws." + configs.Domain
		value.Home_hostname = "home." + configs.Domain
		value.Portal_hostname = "portal." + configs.Domain
		value.Vendor.Hostname = "vendors." + configs.Domain
		value.Vendor.Port = 80
		value.Vendor.Protocol = "http"
	}
	if strings.Contains(filepath, "vendors") {
		value.Ingress.Hosts[0].Host = "vendors." + configs.Domain
	}
	if strings.Contains(filepath, "fileserver") {
		value.Ingress.Hosts[0].Host = "*.fs." + configs.Domain
		value.Domain = configs.Domain
	}
	if strings.Contains(filepath, "polygate") {
		value.Ingress.Hosts[0].Host = "ws." + configs.Domain
		value.Ingress.Hosts[1].Host = "api." + configs.Domain
	}
	if strings.Contains(filepath, "polyapi") {
		value.Ingress.Hosts[0].Host = "polyapi." + configs.Domain
	}
	if strings.Contains(filepath, "form") {
		value.Mongo_host = value.Config.Mongo.Hosts[0]
	}
	if configs.Kafka.Enabled {
		value.Config.Kafka.Broker[0], err = AddrParase(configs.Config.Kafka.Broker[0], namespace)
		if err != nil {
			fmt.Println(err)
		}
		for i, _ := range value.Config.Kafka.Broker {
			if i == 0 {
				continue
			} else {
				value.Config.Kafka.Broker[i] = ""
			}
		}
		value.Kafka.Value = value.Config.Kafka.Broker[0]
	} else {
		value.Config.Kafka = configs.Config.Kafka
		value.Kafka.Value = ""
		for _, k := range configs.Config.Kafka.Broker {
			k_n, _ := AddrParase(k, namespace)
			value.Kafka.Value += k_n
			value.Kafka.Value += ","
		}
		value.Kafka.Value = strings.TrimSuffix(value.Kafka.Value, ",")
	}

	value.Image.Repo = configs.Image.Repo
	value.Image.Tag = configs.Image.Tag
	value.Config.Storage = configs.Config.Storage
	value.Config.Email = configs.Config.Email
	value.ImagePullSecrets = configs.ImagePullSecrets.(string)
	value.Args.Endpoint = configs.Args.Endpoint
	value.Args.Enabled = configs.Args.Enabled
	value.Args.Ip = configs.Args.Ip
	value.Domain = configs.Domain
	if strings.Contains(filepath, "warden") {
		value.Config.JwtKey = uuid.NewV4().String()
	}

	if ngGateWay {
		value.Websocket_hostname = value.Websocket_hostname + ":32032"
		value.Portal_hostname = value.Portal_hostname + ":32032"
		value.Home_hostname = value.Home_hostname + ":32032"
		for _, m := range value.Config.Storage.Storages {
			if m.Name == "minio" {
				m.Domain = m.Domain + ":32032"
			}
		}
	}
	data_file, err := yaml.Marshal(value)
	if err != nil {
		fmt.Println("修改后解析错误")
		return err
	}
	err = ioutil.WriteFile(filepath, data_file, 0644)
	if err != nil {
		fmt.Println("写出到文件错误")
		return err
	}

	return nil
}

func AddrParase(addr, namespace string) (string, error) {
	tmpl, err := template.New("test").Parse(addr)
	if err != nil {
		return "", err
	}
	var buf bytes.Buffer
	err = tmpl.Execute(&buf, namespace)
	if err != nil {
		return "", err
	}
	return buf.String(), nil
}
