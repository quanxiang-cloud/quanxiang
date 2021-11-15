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
	"context"
	"errors"
	"fmt"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"path/filepath"
	"strings"
	"time"
)

func deployMysql(kubeconfig, namespace,sqlName,depPath string,configs *Configs) error {
	if kubeconfig == ""{
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		}else {
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
	pods, err := clientset.CoreV1().Pods(namespace).List(context.TODO(), metav1.ListOptions{})
	var needMysql = true
	for _,pod :=range pods.Items{
		if strings.Contains(pod.Name,"mysql"){
			needMysql = false
		}
	}

	if needMysql{
		err := mysqlInstall(namespace,depPath,"qxp1234",kubeconfig)
		if err != nil {
			return err
		}
		fmt.Println("请稍等.........")
		time.Sleep(30*time.Second)
	}
	mysqlAddress := strings.Split(configs.Config.Mysql.Host,":")[0]
	mysqlPort := strings.Split(configs.Config.Mysql.Host,":")[1]
	mysqlUserName := configs.Config.Mysql.User
	mysqlUserPass := configs.Config.Mysql.Password
	for _,pod :=range pods.Items{
		if strings.Contains(pod.Name,"mysql"){
			command := "kubectl exec -it -n "+ namespace + " --kubeconfig " + kubeconfig +" " + pod.Name + " -- mysql -h" + mysqlAddress+" -u" + mysqlUserName +  " -p" + mysqlUserPass + " -P" + mysqlPort + " --default-character-set=utf8 < " + "./deployment/schemas/" + sqlName
			err := execBash(command)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
