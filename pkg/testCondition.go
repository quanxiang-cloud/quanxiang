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
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net"
	"strings"
	"time"
)
func tcpGather(ip string, port string) bool {
	isConn := false

	address := net.JoinHostPort(ip, port)
	// 5 秒超时
	conn, err := net.DialTimeout("tcp", address, 5*time.Second)

	if err != nil {
		isConn = false
	} else {
		if conn != nil {
			isConn = true
			_ = conn.Close()
		} else {
			isConn = false
		}
	}
	return isConn
}

func InitCondiion(filePath string) (error,map[string]string) {
	var NameMapPort = map[string]string{}
	file,err := ioutil.ReadFile(filePath)
	if err != nil {
		fmt.Println("读取配置文件错误，请检查！！！")
		return err,nil
	}
	err = json.Unmarshal(file,&NameMapPort)
	if err != nil {
		fmt.Println("配置文件格式有问题，请检查！！！")
		return err,nil
	}
	return nil,NameMapPort
}
func TestCondition(filePath string) error {
	err,TestItems := InitCondiion(filePath)
	if err != nil {
		return err
	}
	for itemKey,testItem :=range TestItems{
		ipAndPort := strings.Split(testItem,":")
		isConn := tcpGather(ipAndPort[0],ipAndPort[1])
		if !isConn {
			fmt.Printf("安装前检查失败：%s 没有就绪！！！ \n",itemKey)
			return errors.New("NUILL_INSTALL")
		}
		fmt.Printf("安装前检查成功：%s 已经就绪！！！ \n",itemKey)
	}
	return nil
}