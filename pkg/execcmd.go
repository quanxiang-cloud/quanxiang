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
		fmt.Errorf("stdout报错:%s", err.Error())
		return fmt.Errorf("stdout报错:%s", err.Error())
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		fmt.Errorf("stderr报错:%s", err.Error())
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
