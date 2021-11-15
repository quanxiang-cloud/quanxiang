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
	"fmt"
	"io/ioutil"
	"gopkg.in/yaml.v2"
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
		Mysql struct{
			Host string `yaml:"host"`
			Db string `yaml:"db"`
			User string `yaml:"user"`
			Password  string `yaml:"password"`
			Log bool `yaml:"log"`
		}`yaml:"mysql"`

		Redis struct{
			Addrs []string `yaml:"addrs"`
			Username string `yaml:"username"`
			Password string `yaml:"password"`
		}`yaml:"redis"`
		Elastic struct{
			Host []string `yaml:"host"`
			Log bool `yaml:"log"`
		}`yaml:"elastic"`
		Kafka struct{
			Broker []string `yaml:"broker"`
		}`yaml:"kafka"`
		Mongo struct{
			Hosts []string `yaml:"hosts"`
			Direct bool `yaml:"driect"`
			Credential struct{
				AuthMechanism string `yaml:"authMechanism"`
				AuthSource string `yaml:"authSource"`
				Username string `yaml:"username"`
				Password string `yaml:"password"`
				PasswordSet bool `yaml:"passwordSet"`
			}`yaml:"credential"`
		}`yaml:"mongo"`
		Storage struct{
			Option string `yaml:"option"`
			UrlExpire  int    `yaml:"urlExpire"`
			PartExpire int    `yaml:"partExpire"`
			Launch bool `yaml:"launch"`
			Storages []struct{
				Location   string `yaml:"location"`
				BucketName string `yaml:"bucketName"`
				Name       string `yaml:"name"`
				Protocol   string `yaml:"protocol"`
				Domain     string `yaml:"domain"`
				AccessKey  string `yaml:"accessKey"`
				SecretKey  string `yaml:"secretKey"`
			}`yaml: storages`
		}
		Email struct{
			Emails []struct{
				Emailfrom string `yaml:"emailfrom"`
				Username string `yaml:"username"`
				Aliasname string `yaml:"aliasname"`
				Password string `yaml:"password"`
				Host string `yaml:"host"`
				Port int `yaml:"port"`
			}`yaml:"emails"`
		}`yaml:"email"`
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
func ReadAllValuesFile(configFile string) (*values,error) {
	all := new(values)
	data,err := ioutil.ReadFile(configFile)
	if err != nil {
		fmt.Println("读取value文件失败")
		return nil,err
	}
	err = yaml.Unmarshal(data,all)
	if err != nil {
		return nil,err
	}
	return all,nil
}
func ModifyValuesFile(filepath,configFile string) error {
	all,err := ReadAllValuesFile(configFile)
	if err != nil {
		return err
	}
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
	value.Image.Repo = all.Image.Repo
	value.Image.Tag = all.Image.Tag
	value.Config.Mysql.Host = all.Config.Mysql.Host
	value.Config.Mysql.Password = all.Config.Mysql.Password
	value.Config.Mysql.User = all.Config.Mysql.User
	value.Config.Mysql.Log = all.Config.Mysql.Log
	value.Config.Mongo = all.Config.Mongo
	value.Config.Redis = all.Config.Redis
	value.Config.Kafka = all.Config.Kafka
	value.Config.Elastic = all.Config.Elastic
	value.Config.Storage = all.Config.Storage
	value.Config.Email = all.Config.Email
	value.ImagePullSecrets = all.ImagePullSecrets
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