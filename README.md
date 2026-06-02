# DDNS

<p align="center">
  <img src="https://img.shields.io/badge/ddns--go-v6.x-blue?style=flat-square" alt="ddns-go">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/platform-linux%20%7C%20arm-lightgrey?style=flat-square" alt="Platform">
</p>

> 🚀 一键部署 [ddns-go][ddns-go] — 自动检测 CPU 架构，下载最新版本并注册为系统服务

---

## 📋 目录

- [快速安装](#-快速安装)
- [使用说明](#-使用说明)
- [Webhook 通知](#-webhook-通知)
  - [企业微信](#企业微信)
  - [Telegram](#telegram)
- [相关链接](#-相关链接)

---

## 🚀 快速安装

### 方式一：curl

```bash
bash <(curl -sSL https://raw.githubusercontent.com/sororain/ddns/main/ddns.sh)
```

### 方式二：wget

```bash
wget -qO- https://raw.githubusercontent.com/sororain/ddns/main/ddns.sh | bash
```

### ✅ 安装要求

- 操作系统：Linux（Debian / Ubuntu / CentOS / Alpine 等）
- 权限：需要 **root** 或 **sudo** 权限
- 依赖：`curl`、`wget`、`tar`（脚本会自动安装缺失项）

---

## 📖 使用说明

安装完成后，通过浏览器访问进行配置：

```
http://<服务器IP>:9876
```

> 首次访问会进入初始化配置页面，需填写 DNS 服务商凭证（支持阿里云、腾讯云、Cloudflare、华为云等）和需要解析的域名。

**默认配置：**

| 参数 | 值 | 说明 |
|------|-----|------|
| 检查间隔 | `10 秒` | 每 10 秒检查一次 IP 变化 |
| 缓存时间 | `360 分钟` | DNS 记录缓存时间 |
| 配置文件 | `/opt/ddns-go/.ddns_go_config.yaml` | 配置文件路径 |

---

## 🔔 Webhook 通知

### 企业微信

<details>
<summary>点击展开配置步骤</summary>

1. 下载企业微信 → 左上角 **三横杠** → **全新创建企业** → 选择 **个人组件团队**（创建个人企业群聊）
2. 进入群聊 → 添加 **群机器人** → 复制机器人 Webhook URL
3. 粘贴到 ddns-go 后台的 Webhook URL 地址栏
4. RequestBody 填入以下 JSON：

```json
{
  "msgtype": "markdown",
  "markdown": {
    "content": "公网IP变更：\n- IPv4地址：#{ipv4Addr}\n- 域名更新结果：#{ipv4Result}\n- IPv6地址：#{ipv6Addr}\n- 域名更新结果：#{ipv6Result}\n"
  }
}
```

</details>

### Telegram

<details>
<summary>点击展开配置步骤</summary>

使用专用机器人 [@DDNSGoBot][DDNSGoBot] 接收通知。

1. 打开 Telegram，搜索并启用 [@DDNSGoBot][DDNSGoBot]
2. 发送命令 `/gethook`
3. 复制返回的 **Webhook URL**，粘贴到 ddns-go 后台
4. 复制 **RequestBody**，粘贴到 ddns-go 后台

```json
{
  "ipv4": {
    "result": "#{ipv4Result}",
    "addr": "#{ipv4Addr}",
    "domains": "#{ipv4Domains}"
  },
  "ipv6": {
    "result": "#{ipv6Result}",
    "addr": "#{ipv6Addr}",
    "domains": "#{ipv6Domains}"
  }
}
```

> 注：未启用 IPv4 或 IPv6 可删除对应 Object

</details>

---

## 🔗 相关链接

- [ddns-go][ddns-go] — 使用的 DDNS 工具
- [@DDNSGoBot][DDNSGoBot] — Telegram 通知机器人
- [ddns-telegram-bot](https://github.com/WingLim/ddns-telegram-bot) — Telegram 机器人源码

[ddns-go]: https://github.com/jeessy2/ddns-go
[DDNSGoBot]: https://t.me/DDNSGoBot
