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
	"bufio"
	"fmt"
	"io"
	"os/exec"
	"strings"
)

func execBash(command string) error {
	cmd := exec.Command("/bin/bash", "-c", command)
	// 非阻塞输出
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return fmt.Errorf("stdout报错:%s", err.Error())
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		return fmt.Errorf("stderr报错:%s", err.Error())
	}

	cmd.Start()
	reader := bufio.NewReader(stdout)
	for {
		_, err2 := reader.ReadString('\n')
		if err2 != nil || io.EOF == err2 {
			break
		}
		//fmt.Printf("%s", line)
	}
	readerstderr := bufio.NewReader(stderr)
	for {
		stderrs, err2 := readerstderr.ReadString('\n')
		if err2 != nil || io.EOF == err2 {
			break
		}
		if strings.Contains(strings.ToLower(stderrs),"err") {
			fmt.Printf("%s", stderrs)
		}
	}
	cmd.Wait()
	return nil
}
