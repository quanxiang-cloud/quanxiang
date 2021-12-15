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
	"gopkg.in/yaml.v2"
	"text/template"
)
//project
type values struct {
	Image struct{
		Name string `yaml:"name"`
		Repo string `yaml:"repo"`
		Tag string `yaml:"tag"`
	}
	Namespace string `yaml:"namespace"`
	ImagePullSecrets string `yaml:"imagePullSecrets"`
	Service struct{
		Type string `yaml:"type"`
		Port int `yaml:"port"`
		RpcPort int `yaml:"rpcPort"`
	}
	NameOverride string `yaml:"nameOverride"`
	FullnameOverride string `yaml:"fullnameOverride"`
	Websocket_hostname string `yaml:"websocket_hostname"`
	Home_hostname string `yaml:"home_hostname"`
	Portal_hostname string `yaml:"portal_hostname"`
	ServiceAccount struct{
		Name string `yaml:"name"`
	}`yaml:"serviceAccount"`
	PodSecurityContext map[string]interface{} `yaml:"podSecurityContext"`
	SecurityContext map[string]interface{} `yaml:"securityContext"`
	Config struct{
		Mysql Mysql
		Redis Redis
		Elastic Elastic
		Kafka Kafka
		Mongo Mongo
		Storage Storage
		Email Email
	}
	Ingress struct{
		Enabled bool `yaml:"enabled"`
		Hosts []struct{
			Host string  `yaml:"host"`
			//Paths []struct{
			//	Path string `yaml: path`
			//	FullName string `yaml: fullName`
			//	SvcPort int `yaml svcPort`
			//}`yaml: paths`
			Paths []map[string]interface{}`yaml:"paths"`
		}`yaml:"hosts"`
	}
	App struct{
		Kubernetes struct{
			Io struct{
				Name string `yaml:"name"`
			}`yaml:"io"`
		}`yaml:"kubernetes"`
	}
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
func ModifyValuesFile(filepath,namespace string,configs *Configs,ngGateWay bool) error {
	//all,err := ReadAllValuesFile(configFile)
	//if err != nil {
	//	return err
	//}
	value := new(values)
	data,err := ioutil.ReadFile(filepath)
	if err != nil {
		fmt.Println("读取value文件失败")
		return err
	}
	err = yaml.Unmarshal(data,value)
	if err != nil {
		fmt.Println("读取数据失败")
		return err
	}
	if configs.Mysql.Enabled{
		value.Config.Mysql.Host,err = AddrParase(configs.Config.Mysql.Host,namespace)
		if err != nil {
			return err
		}
		value.Config.Mysql.Password = configs.Config.Mysql.Password
		value.Config.Mysql.User = configs.Config.Mysql.User
		value.Config.Mysql.Log = configs.Config.Mysql.Log
	}else {
		value.Config.Mysql.Host = configs.Config.Mysql.Host
		value.Config.Mysql.Password = configs.Config.Mysql.Password
		value.Config.Mysql.User = configs.Config.Mysql.User
		value.Config.Mysql.Log = configs.Config.Mysql.Log
	}
	if configs.Redis.Enabled{
		for i,_ := range value.Config.Redis.Addrs{
			value.Config.Redis.Addrs[i],err = AddrParase(configs.Config.Redis.Addrs[i],namespace)
			if err != nil {
				return err
			}
		}
		value.Config.Redis.Username = configs.Config.Redis.Username
		value.Config.Redis.Password = configs.Config.Redis.Password
	}else {
		value.Config.Redis = configs.Config.Redis
	}
	if configs.Elastic.Enabled{
		value.Config.Elastic.Host[0],err = AddrParase(configs.Config.Elastic.Host[0],namespace)
		for i,_ := range value.Config.Elastic.Host{
			if i == 0{
				continue
			}else{
				value.Config.Elastic.Host[i] = ""
			}
		}
		value.Config.Elastic.Log = configs.Config.Elastic.Log
	}else{
		value.Config.Elastic = configs.Config.Elastic
	}
	if configs.Mongo.Enabled{
		value.Config.Mongo.Hosts[0],err = AddrParase(configs.Config.Mongo.Hosts[0],namespace)
		value.Config.Mongo.Credential = configs.Config.Mongo.Credential
		value.Config.Mongo.Direct = configs.Config.Mongo.Direct
	}else {
		value.Config.Mongo = configs.Config.Mongo
	}
	if configs.Kafka.Enabled{
		value.Config.Kafka.Broker[0],err = AddrParase(configs.Config.Kafka.Broker[0],namespace)
		for i,_ := range value.Config.Kafka.Broker{
			if i == 0{
				continue
			}else{
				value.Config.Kafka.Broker[i] = ""
			}
		}
	}else {
		value.Config.Kafka = configs.Config.Kafka
	}

	value.Image.Repo = configs.Image.Repo
	value.Image.Tag = configs.Image.Tag
	value.Config.Storage = configs.Config.Storage
	value.Config.Email = configs.Config.Email
	value.ImagePullSecrets = configs.ImagePullSecrets.(string)
	if ngGateWay{
		value.Websocket_hostname = value.Websocket_hostname + ":32032"
		value.Portal_hostname = value.Portal_hostname + ":32032"
		value.Home_hostname = value.Home_hostname + ":32032"
		for _,m := range value.Config.Storage.Storages{
			if m.Name == "minio"{
				m.Domain = m.Domain + ":32032"
			}
		}
	}
	data_file,err := yaml.Marshal(value)
	if err != nil {
		fmt.Println("修改后解析错误")
		return err
	}
	err = ioutil.WriteFile(filepath,data_file,0644)
	if err != nil {
		fmt.Println("写出到文件错误")
		return err
	}

	return nil
}

func AddrParase(addr,namespace string) (string,error) {
	tmpl, err := template.New("test").Parse(addr)
	if err != nil {
		return "",err
	}
	var buf bytes.Buffer
	err = tmpl.Execute(&buf,namespace)
	if err != nil {
		return "",err
	}
	return buf.String(),nil
}