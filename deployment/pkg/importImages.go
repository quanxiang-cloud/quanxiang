package pkg

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
	"golang.org/x/net/context"
)

func importImages(registry, depFile, repoUser, repoPass string) {
	fmt.Println()
	fmt.Println("----------------------------------------->开始导入镜像")
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		panic(err)
	}
	releases, _ := ioutil.ReadDir(depFile + "/images")
	for _, release := range releases {
		fileName := depFile + "/images/" + release.Name()
		file, err := os.OpenFile(fileName, os.O_RDONLY, 0666)
		if err != nil {
			log.Fatalf("Error loading image %s, %s", fileName, err.Error())
		} else {
			defer file.Close()
			imageLoadResponse, err := cli.ImageLoad(context.Background(), file, true)
			if err != nil {
				log.Fatal(err)
			}
			body, err := ioutil.ReadAll(imageLoadResponse.Body)
			if err != nil {
				fmt.Println(err)
			}
			imageTag := strings.Replace(strings.Split(string(body), ":")[3], "\\n\"}", "", -1)
			imageSource := strings.TrimSpace(strings.Split(string(body), ":")[2] + ":" + imageTag)
			imageDes := registry + "/" + strings.TrimSpace(strings.Split(strings.Split(string(body), ":")[2], "/")[len(strings.Split(strings.Split(string(body), ":")[2], "/"))-1]) +
				":" + imageTag
			imageDes = strings.TrimSpace(imageDes)
			err = cli.ImageTag(context.Background(), imageSource, imageDes)
			if err != nil {
				log.Fatal(err)
			}

			user := repoUser
			password := repoPass
			authConfig := types.AuthConfig{Username: user, Password: password}
			encodedJSON, err := json.Marshal(authConfig)
			if err != nil {
				panic(err)
			}
			authStr := base64.URLEncoding.EncodeToString(encodedJSON)
			pushReader, err := cli.ImagePush(context.Background(), imageDes, types.ImagePushOptions{
				All:           false,
				RegistryAuth:  authStr,
				PrivilegeFunc: nil,
			})
			if err != nil {
				panic(err.Error())
			}
			defer pushReader.Close()
			buf1 := new(bytes.Buffer)
			buf1.ReadFrom(pushReader)
			s1 := buf1.String()
			if strings.Contains(s1, "err") {
				fmt.Println(s1)
			} else {
				fmt.Printf("----------------------------------------->%s 镜像导入完成 \n", imageDes)
			}

			//删除原镜像 *****净化环境
			_, err = cli.ImageRemove(context.Background(), imageSource, types.ImageRemoveOptions{})
			if err != nil {
				panic(err.Error())
			}
			//删除生成镜像
			_, err = cli.ImageRemove(context.Background(), imageDes, types.ImageRemoveOptions{})
			if err != nil {
				panic(err.Error())
			}
		}
	}
}
