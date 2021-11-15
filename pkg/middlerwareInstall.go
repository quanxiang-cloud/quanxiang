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
	"errors"
	"fmt"
	"k8s.io/client-go/util/homedir"
	"path/filepath"
)

func middlewareInstall(namespace,depPath,kubeconfig string,configs *Configs) (bool,error) {
	needMiddleware := false
	if kubeconfig == ""{
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		}else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return needMiddleware,errors.New("NO_KUBECONFIG")
		}
	}
	if configs.Mysql.Enabled{
		needMiddleware = true
		err := mysqlInstall(namespace,depPath,configs.Mysql.RootPassword,kubeconfig)
		if err != nil {
			fmt.Println("安装mysql时出现错误，请检查")
			return needMiddleware,err
		}
	}
	if configs.Elastic.Enabled{
		needMiddleware = true
		err := elasticsearchInstall(namespace,depPath,kubeconfig)
		if err != nil {
			fmt.Println("安装elasticsearch时出现错误，请检查")
			return needMiddleware,err
		}
	}
	if configs.Kafka.Enabled{
		needMiddleware = true
		err := kafKaInstall(namespace,depPath,kubeconfig)
		if err != nil {
			fmt.Println("安装kafka时出现错误，请检查")
			return needMiddleware,err
		}
	}
	if configs.Redis.Enabled{
		needMiddleware = true
		err := redisInstall(namespace,depPath,configs.Redis.Password,kubeconfig)
		if err != nil {
			fmt.Println("安装redis时出现错误，请检查")
			return needMiddleware,err
		}
	}
	if configs.Mongo.Enabled{
		needMiddleware = true
		err := mongodbInstall(namespace,depPath,configs.Mongo.Password,kubeconfig)
		if err != nil {
			fmt.Println("安装mongodb时出现错误，请检查")
			return needMiddleware,err
		}

	}
	if configs.Minio.Enabled{
		needMiddleware = true
		err := minio(namespace,depPath,configs.Minio.AccessKey,configs.Minio.SecretKey,kubeconfig)
		if err != nil {
			fmt.Println("安装minio时出现错误，请检查")
			return needMiddleware,err
		}
	}

	return needMiddleware,nil
}
func mysqlInstall(namespace,depPath,password,kubeconfig string) error {
	fmt.Println("--------->开始部署MySQL")
	command := "helm install mysql -n " + namespace + " " + depPath+ "/middleware_deployment/mysql --set mysqlRootPassword="+password + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func zookeeperInstall(namespace,depPath,kubeconfig string) error {
	fmt.Println("--------->开始部署Zookeeper")
	command := "helm install zookeeper -n " + namespace +  " " + depPath+ "/middleware_deployment/zookeeper"  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	fmt.Println("--------->zookeeper安装完成")
	return nil

}
func kafKaInstall(namespace,depPath,kubeconfig string)  error {
	fmt.Println("--------->开始部署Kafka")
	err := zookeeperInstall(namespace,depPath,kubeconfig )
	if err != nil {
		return err
	}
	command := "helm install kafka -n " + namespace +  " " + depPath+ "/middleware_deployment/kafka"  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err = execBash(command)
	if err != nil {
		return err
	}
	return nil


}

func redisInstall(namespace,depPath,password,kubeconfig string) error {
	fmt.Println("--------->开始部署Redis")
	command := "helm install redis-cluster-operator -n " + namespace +  " " + depPath+ "/middleware_deployment/redis-cluster-operator --set operator.password="+password  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}

func mongodbInstall(namespace,depPath,password,kubeconfig string) error {
	fmt.Println("--------->开始部署mongodb")
	command := "helm install mongodb -n " + namespace +  " " + depPath+ "/middleware_deployment/mongodb --set mongodbRootPassword="+password  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func elasticsearchInstall(namespace,depPath,kubeconfig string) error {
	fmt.Println("--------->开始部署elasticsearch")
	command := "helm install elasticsearch -n " + namespace +  " " + depPath+ "/middleware_deployment/elasticsearch"  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func minio(namespace,depPath,accessKey,secretKey,kubeconfig string) error {
	fmt.Println("--------->开始部署minio")
	command := "helm install minio -n " + namespace +  " " + depPath + "/middleware_deployment/minio --set accessKey="+ accessKey + " --set secretKey=" + secretKey  + " --kubeconfig " + kubeconfig + " --timeout 1800s"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}