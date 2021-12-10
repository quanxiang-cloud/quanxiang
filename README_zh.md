<p align="center">
  <a href="https://docs.clouden.io" target="blank"><img src="https://qxp-public.pek3b.qingstor.com/qxp_vertical_logo.svg" width="300" alt="Quanxiang Cloud Logo" /></a>
</p>
<p align="center">
  <br/>
  <a href="https://docs.clouden.io" target="blank">
    QuanXiang
  </a>
</p>
<p align="center">
  <b> QuanXiang cloud is a powerful, pluggable open source low-code platform.</b>
</p>

----



> [English](./README.md) | 中文

## QuanXiang 是什么

**QuanXiang**（全象云低代码平台）是一个基于云原生的、完全容器化的开源低代码平台，用于辅助构建企业各类数字化应用。平台目前提供云上`无代码`和`低代码`两种应用开发模式，屏蔽了技术的复杂度，支持`可视化设计`，让开发人员和业务用户能够通过简单的拖拽、参数配置等方式快速完成应用开发。作为一个集低代码开发能力、 IDaaS 身份认证能力、容器 DevOps 能力于一体的多应用集成和管理平台，**QuanXiang** 支持快速构建应用、便捷维护管理应用、企业存量业务及全象云构建业务的集成。

除此之外，**QuanXiang** 还为前端和移动端开发工程师提供了丰富的自定义功能，包括组件、页面、应用模板级别的自定义，以及为后端开发工程师提供了 FaaS 能力、结合 API 编排能力。

### 简洁直观的设计界面
界面图



## 平台功能

QuanXiang 围绕应用设计、开发、部署、运维全生命周期管理，构建低代码生态，为企业的信息化数智化建设赋能。平台核心能力如下：

<details>
  <summary><b> 🚀 快速应用开发</b></summary>
  <li>可视化设计器：用户通过简单的拖拽、参数配置等方式就能完成页面设计、工作流编排、数据模型设计和角色权限的定义。
  <li>表单引擎：系统提供丰富的页面组件，能够满足页面呈现的自定义组件需求。
  <li>工作流引擎：包含灵活的触发方式和丰富的流程组件，支持多种触发方式，表单数据触发、时间触发、表单时间触发等。同时提供审批、填写等人为节点处理，同时支持数据新增、数据更新等自动流程节点处理。同时提供规则引擎的能力，满足复杂业务下的逻辑定义。
  </details>

<details>
  <summary><b>☁️ 多云部署和运维</b></summary>
  <li>QuanXiang 基于 Kubernetes 的容器化部署方案，CI/CD 持续交付部署，为应用的平滑部署、稳定运行保驾护航，大大降低了应用上线后迭代升级的风险和复杂度。
  <li>支持不同云厂商的部署及运维。
  <li>平台提供系统日志，支持查看所有操作记录。
  </details>

<details>
  <summary><b>🤖 多端兼容适配</b></summary>
  平台应用均可一次设计，在多端灵活适配。目前支持一键发布为 WEB 应用、Native APP、微信小程序。
  </details>
<details>
  <summary><b>🧑‍💻 灵活组织管理</b></summary>
  <li>企业通讯录：提供多种管理通讯录方式，帮助企业快速完成组织的构建。
  <li>角色管理：企业角色权限按需细分，保障平台账户访问安全和数据安全。
</details>
<details>
  <summary><b>🗂 系统连接能力</b></summary>
  <li>平台内部支持跨应用间的数据连接，提供了不同粒度的数据连接能力，包括：表与表之间的数据联动更新、字段与字段间的联动交互。
  <li>平台支持不同粒度的方案集成，包括组件集成、页面集成、应用集成。
  </details>


<details>
  <summary><b>🧩 可插拔的架构</b></summary>
  QuanXiang 是云原生、分布式架构的平台系统。各个核心服务（聚合类服务除外）采用完全解耦的、低内聚的方式设计，服务之间通过 API 接口进行访问。
  </details>



## 适用场景
待补充



## 架构说明

全象云低代码平台将前端与后端分离，提供即插即用（plug-and-play）、微服务的架构，并且支持不同的开发语言、开发框架。平台分为：应用层，对接层，数据处理层及基础层。

![architecture](/doc/images/architecture.png)



## 快速安装

全象云低代码平台提供了一套快速安装程序，使用者只需一条指令即可安装全象云低代码平台，目前支持 [在 KubeSphere 环境中安装](#在Kubesphere环境中安装（推荐使用）)。



### 原生 KuberNetes 环境上安装

 敬请期待。



## 快速开始

请参考官方文档[快速入门](https://docs.clouden.io/quickstart/app_modeling/)。

## 交流互动

- 微信公众号：全象云低代码
- Slack Channel
- 中文论坛