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

package main

import (
	"quanxiang/cmd"
)


func main() {
	cmd.Execute()
	//router, err := restful.NewRouter()
	//if err != nil {
	//	panic(err)
	//}
	//go router.Run()
	//
	//c := make(chan os.Signal, 1)
	//signal.Notify(c, syscall.SIGHUP, syscall.SIGQUIT, syscall.SIGTERM, syscall.SIGINT)
	//for {
	//	s := <-c
	//	switch s {
	//	case syscall.SIGQUIT, syscall.SIGTERM, syscall.SIGINT:
	//		router.Close()
	//		return
	//	case syscall.SIGHUP:
	//	default:
	//		return
	//	}
	//}
}
