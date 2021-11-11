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
	"time"
)

func statusCheck(kubeconfig, namespace string) error {
	if kubeconfig == ""{
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		}else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return errors.New("NO_KUBECONFIG")
		}
	}else {
		kubeconfig = kubeconfig
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
	for {
		pods, err := clientset.CoreV1().Pods(namespace).List(context.TODO(), metav1.ListOptions{})
		if err != nil {
			panic(err.Error())
		}

		podCount := 0
		for _,pod := range pods.Items{
			containerFlag := 0
			for _,stat := range pod.Status.Conditions{
				if stat.Status == "True"{
					containerFlag++
				}
				if containerFlag == len(pod.Status.Conditions){
					podCount++
				}
			}
		}
		if podCount == len(pods.Items) {
			fmt.Println("----------------------------------------->安装成功")
			return nil
		}else {
			fmt.Println("----------------------------------------->仍有服务没有启动完成，详细信息如下")

			for _,pod := range pods.Items{
				for _,reason := range pod.Status.ContainerStatuses{
					if reason.State.Waiting != nil {
						fmt.Printf("POD %s 还未就绪, 原因为：%s \n",pod.Name,reason.State.Waiting.Reason)
					}else if reason.State.Terminated != nil {
						fmt.Printf("POD %s 还未就绪，原因为：%s \n", pod.Name, reason.State.Terminated.Reason)
					}else{
						continue
					}

				}

			}
		}
		fmt.Printf("--------------------------命名空间%s下有 %d 个 pods--------------------------\n", namespace,len(pods.Items))
		time.Sleep(10 * time.Second)
	}
}
