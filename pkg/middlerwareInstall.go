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
	"strings"
)

func middlewareInstall(namespace,depPath,kubeconfig,registry string,configs *Configs,isOffline bool) (bool,error) {
	needMiddleware := false
	if kubeconfig == ""{
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		}else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return needMiddleware,errors.New("NO_KUBECONFIG")
		}
	}
	if !isOffline{
		err := installDapr(depPath,kubeconfig)
		if err != nil {
			fmt.Println("安装dapr时出现错误，请检查")
			return needMiddleware,err
		}
		if configs.Mysql.Enabled{
			needMiddleware = true
			err := mysqlInstall(namespace,depPath,configs.Mysql.RootPassword,kubeconfig,configs.Persis)
			if err != nil {
				fmt.Println("安装mysql时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Elastic.Enabled{
			needMiddleware = true
			err := elasticsearchInstall(namespace,depPath,kubeconfig, configs.Persis)
			if err != nil {
				fmt.Println("安装elasticsearch时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Etcd.Enabled{
			needMiddleware = true
			err := etcdInstall(namespace,depPath,kubeconfig,configs.Persis)
			if err != nil {
				fmt.Println("安装minio时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Kafka.Enabled{
			needMiddleware = true
			err := kafKaInstall(namespace,depPath,kubeconfig,configs.Persis)
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
			err := mongodbInstall(namespace,depPath,configs.Mongo.Password,kubeconfig,configs.Persis)
			if err != nil {
				fmt.Println("安装mongodb时出现错误，请检查")
				return needMiddleware,err
			}

		}
		if configs.Minio.Enabled{
			needMiddleware = true
			err := minio(namespace,depPath,configs.Minio.AccessKey,configs.Minio.SecretKey,configs.Args.Endpoint,kubeconfig,configs.Persis)
			if err != nil {
				fmt.Println("安装minio时出现错误，请检查")
				return needMiddleware,err
			}
		}
	}else {
		err := installDaprOffLine(depPath,kubeconfig,registry)
		if err != nil {
			fmt.Println("安装dapr时出现错误，请检查")
			return needMiddleware,err
		}
		if configs.Mysql.Enabled{
			needMiddleware = true
			err := mysqlInstallOffLine(namespace,depPath,configs.Mysql.RootPassword,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装mysql时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Elastic.Enabled{
			needMiddleware = true
			err := elasticsearchInstallOffLine(namespace,depPath,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装elasticsearch时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Etcd.Enabled{
			needMiddleware = true
			err := etcdInstallOffLine(namespace,depPath,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装minio时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Kafka.Enabled{
			needMiddleware = true
			err := kafKaInstallOffLine(namespace,depPath,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装kafka时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Redis.Enabled{
			needMiddleware = true
			err := redisInstallOffLine(namespace,depPath,configs.Redis.Password,kubeconfig,registry)
			if err != nil {
				fmt.Println("安装redis时出现错误，请检查")
				return needMiddleware,err
			}
		}
		if configs.Mongo.Enabled{
			needMiddleware = true
			err := mongodbInstallOffLine(namespace,depPath,configs.Mongo.Password,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装mongodb时出现错误，请检查")
				return needMiddleware,err
			}

		}
		if configs.Minio.Enabled{
			needMiddleware = true
			err := minioOffLine(namespace,depPath,configs.Minio.AccessKey,configs.Minio.SecretKey,configs.Args.Endpoint,kubeconfig,registry,configs.Persis)
			if err != nil {
				fmt.Println("安装minio时出现错误，请检查")
				return needMiddleware,err
			}
		}
	}


	return needMiddleware,nil
}
func mysqlInstall(namespace,depPath,password,kubeconfig string,persis Persis) error {
	fmt.Println("--------->开始部署MySQL")
	var command string
	if persis.Enabled{
		command = "helm install mysql -n " + namespace + " " + depPath+ "/middleware_deployment/mysql --set mysqlRootPassword="+password + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install mysql -n " + namespace + " " + depPath+ "/middleware_deployment/mysql --set mysqlRootPassword="+password + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	}

	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func mysqlInstallOffLine(namespace,depPath,password,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署MySQL")
	var command string
	if persis.Enabled{
		command = "helm install mysql -n " + namespace + " " + depPath+ "/middleware_deployment/mysql --set mysqlRootPassword="+
			password + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image=" + registry + "/mysql --set busybox.image=" + registry +
			"/busybox --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else {
		command = "helm install mysql -n " + namespace + " " + depPath+ "/middleware_deployment/mysql --set mysqlRootPassword="+
			password + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image=" + registry + "/mysql --set busybox.image=" + registry +
			"/busybox"
	}

	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func zookeeperInstall(namespace,depPath,kubeconfig string,persis Persis) error {
	fmt.Println("--------->开始部署Zookeeper")
	var command string
	if persis.Enabled{
		command = "helm install zookeeper -n " + namespace +  " " + depPath+ "/middleware_deployment/zookeeper"  + " --kubeconfig " + kubeconfig +
			" --timeout 1800s --create-namespace --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install zookeeper -n " + namespace +  " " + depPath+ "/middleware_deployment/zookeeper"  + " --kubeconfig " + kubeconfig +
			" --timeout 1800s --create-namespace"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	fmt.Println("--------->zookeeper安装完成")
	return nil

}
func zookeeperInstallOffLine(namespace,depPath,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署Zookeeper")
	var command string
	if persis.Enabled{
		command = "helm install zookeeper -n " + namespace +  " " + depPath+ "/middleware_deployment/zookeeper"  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/zookeeper --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else {
		command = "helm install zookeeper -n " + namespace +  " " + depPath+ "/middleware_deployment/zookeeper"  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/zookeeper"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	fmt.Println("--------->zookeeper安装完成")
	return nil

}

func kafKaInstall(namespace,depPath,kubeconfig string,persis Persis)  error {
	fmt.Println("--------->开始部署Kafka")
	err := zookeeperInstall(namespace,depPath,kubeconfig,persis )
	if err != nil {
		return err
	}
	var command string
	if persis.Enabled{
		command = "helm install kafka -n " + namespace +  " " + depPath+ "/middleware_deployment/kafka"  + " --kubeconfig " + kubeconfig +
			" --timeout 1800s --create-namespace --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install kafka -n " + namespace +  " " + depPath+ "/middleware_deployment/kafka"  + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	}

	err = execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func kafKaInstallOffLine(namespace,depPath,kubeconfig,registry string,persis Persis)  error {
	fmt.Println("--------->开始部署Kafka")
	err := zookeeperInstallOffLine(namespace,depPath,kubeconfig,registry,persis)
	if err != nil {
		return err
	}
	var command string
	if persis.Enabled{
		command = "helm install kafka -n " + namespace +  " " + depPath+ "/middleware_deployment/kafka"  + " --kubeconfig " +
			kubeconfig + " --timeout 1800s --create-namespace --set image=" + registry + "/cp-kafka --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install kafka -n " + namespace +  " " + depPath+ "/middleware_deployment/kafka"  + " --kubeconfig " +
			kubeconfig + " --timeout 1800s --create-namespace --set image=" + registry + "/cp-kafka"
	}
	err = execBash(command)
	if err != nil {
		return err
	}
	return nil
}

func redisInstall(namespace,depPath,password,kubeconfig string) error {
	fmt.Println("--------->开始部署Redis")
	command := "helm install redis-cluster-operator -n " + namespace +  " " + depPath+ "/middleware_deployment/redis-cluster-operator --set operator.password="+password  + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func redisInstallOffLine(namespace,depPath,password,kubeconfig,registry string) error {
	fmt.Println("--------->开始部署Redis")
	command := "helm install redis-cluster-operator -n " + namespace +  " " + depPath +
		"/middleware_deployment/redis-cluster-operator --set operator.password="+password  + " --kubeconfig " + kubeconfig +
		" --timeout 1800s --create-namespace --set operator.image_source=" + registry + "/redis-cluster-operator --set operator.image_redis=" +
		registry + "/redis"
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}

func mongodbInstall(namespace,depPath,password,kubeconfig string,persis Persis) error {
	fmt.Println("--------->开始部署mongodb")
	var command string
	if persis.Enabled{
		command = "helm install mongodb -n " + namespace +  " " + depPath+ "/middleware_deployment/mongodb --set mongodbRootPassword="+password  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else {
		command = "helm install mongodb -n " + namespace +  " " + depPath+ "/middleware_deployment/mongodb --set mongodbRootPassword="+password  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}
func mongodbInstallOffLine(namespace,depPath,password,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署mongodb")
	var command string
	if persis.Enabled{
		command = "helm install mongodb -n " + namespace +  " " + depPath+ "/middleware_deployment/mongodb --set mongodbRootPassword="+
			password  + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image.registry=" + registry + " --set image.repository=" +
			"mongodb --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install mongodb -n " + namespace +  " " + depPath+ "/middleware_deployment/mongodb --set mongodbRootPassword="+
			password  + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set image.registry=" + registry + " --set image.repository=" +
			"mongodb"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil

}

func elasticsearchInstall(namespace,depPath,kubeconfig string, persis Persis) error {
	fmt.Println("--------->开始部署elasticsearch")
	var command string
	if persis.Enabled{
		command = "helm install elasticsearch -n " + namespace +  " " + depPath+ "/middleware_deployment/elasticsearch"  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set persistence.enabled=true --set volumeClaimTemplate.storageClassName=" + persis.StorageClassName
	}else{
		command = "helm install elasticsearch -n " + namespace +  " " + depPath+ "/middleware_deployment/elasticsearch"  + " --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func elasticsearchInstallOffLine(namespace,depPath,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署elasticsearch")
	var command string
	if persis.Enabled{
		command = "helm install elasticsearch -n " + namespace +  " " + depPath+ "/middleware_deployment/elasticsearch"  +
			" --kubeconfig "+ kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/elasticsearch-oss --set initImage.repository=" +
			registry + "/busybox --set persistence.enabled=true --set volumeClaimTemplate.storageClassName=" + persis.StorageClassName
	}else{
		command = "helm install elasticsearch -n " + namespace +  " " + depPath+ "/middleware_deployment/elasticsearch"  +
			" --kubeconfig "+ kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/elasticsearch-oss --set initImage.repository=" +
			registry + "/busybox"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}

func etcdInstall(namespace,depPath,kubeconfig string,persis Persis) error {
	fmt.Println("--------->开始部署etcd")
	var command string
	path := depPath + "/middleware_deployment/etcd-operator/values-persis.yaml"
	if persis.Enabled{
		command = "helm install etcd-operator -n " + namespace +  " " + depPath + "/middleware_deployment/etcd-operator --kubeconfig " + kubeconfig +
			" --timeout 1800s  --set etcdCluster.pod.persistentVolumeClaimSpec.storageClassName="+ persis.StorageClassName + " -f " + path
	}else{
		command = "helm install etcd-operator -n " + namespace +  " " + depPath + "/middleware_deployment/etcd-operator --kubeconfig " + kubeconfig + " --timeout 1800s"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func etcdInstallOffLine(namespace,depPath,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署etcd")
	var command string
	path := depPath + "/middleware_deployment/etcd-operator/values-persis.yaml"
	if persis.Enabled{
		command = "helm install etcd-operator -n " + namespace +  " " +
			depPath + "/middleware_deployment/etcd-operator --kubeconfig " +
			kubeconfig + " --timeout 1800s --set etcdOperator.image.repository=" + registry + "/etcd-operator --set backupOperator.image.repository=" + registry +
			"/etcd-operator --set restoreOperator.image.repository=" + registry + "/etcd-operator --set etcdCluster.image.repository=" + registry + "/etcd --set etcdCluster.pod.busyboxImage=" +
			registry + "/busybox:1.28.0-glibc --set etcdCluster.pod.persistentVolumeClaimSpec.storageClassName="+ persis.StorageClassName + " -f " + path
	}else{
		command = "helm install etcd-operator -n " + namespace +  " " +
			depPath + "/middleware_deployment/etcd-operator --kubeconfig " +
			kubeconfig + " --timeout 1800s --set etcdOperator.image.repository=" + registry + "/etcd-operator --set backupOperator.image.repository=" + registry +
			"/etcd-operator --set restoreOperator.image.repository=" + registry + "/etcd-operator --set etcdCluster.image.repository=" + registry + "/etcd --set etcdCluster.pod.busyboxImage=" + registry + "/busybox:1.28.0-glibc"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func minio(namespace,depPath,accessKey,secretKey,envdomain,kubeconfig string,persis Persis) error {
	fmt.Println("--------->开始部署minio")
	envdomain = strings.Split(envdomain,":")[0]
	var command string
	if persis.Enabled{
		command = "helm install minio -n " + namespace +  " " + depPath +
			"/middleware_deployment/minio --set accessKey="+
			accessKey + " --set secretKey=" + secretKey + " --set env=fs." + envdomain  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else {
		command = "helm install minio -n " + namespace +  " " + depPath +
			"/middleware_deployment/minio --set accessKey="+
			accessKey + " --set secretKey=" + secretKey + " --set env=fs." + envdomain  +
			" --kubeconfig " + kubeconfig + " --timeout 1800s --create-namespace"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func minioOffLine(namespace,depPath,accessKey,secretKey,envdomain,kubeconfig,registry string,persis Persis) error {
	fmt.Println("--------->开始部署minio")
	envdomain = strings.Split(envdomain,":")[0]
	var command string
	if persis.Enabled{
		command = "helm install minio -n " + namespace +
			" " + depPath + "/middleware_deployment/minio --set accessKey="+ accessKey +
			" --set secretKey=" + secretKey + " --set env=fs." + envdomain  + " --kubeconfig " +
			kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/minio --set persistence.enabled=true --set persistence.storageClass=" + persis.StorageClassName
	}else{
		command = "helm install minio -n " + namespace +
			" " + depPath + "/middleware_deployment/minio --set accessKey="+ accessKey +
			" --set secretKey=" + secretKey + " --set env=fs." + envdomain  + " --kubeconfig " +
			kubeconfig + " --timeout 1800s --create-namespace --set image.repository=" + registry + "/minio"
	}
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func installDapr(depfile,kubeconfig string) error {
	fmt.Println("--------->开始部署dapr")
	command := "helm upgrade dapr "  + depfile + "/middleware_deployment/dapr --install --version=1.5 --namespace dapr-system --create-namespace --wait --kubeconfig " + kubeconfig
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}
func installDaprOffLine(depfile,kubeconfig,registry string) error {
	fmt.Println("--------->开始部署dapr")
	command := "helm upgrade dapr "  + depfile + "/middleware_deployment/dapr --install --version=1.5 --namespace dapr-system --create-namespace --wait --kubeconfig " + kubeconfig + " --set global.registry="+registry
	err := execBash(command)
	if err != nil {
		return err
	}
	return nil
}