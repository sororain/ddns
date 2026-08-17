# DDNS

<p align="center">
  <img src="https://img.shields.io/badge/ddns--go-v6.x-blue?style=flat-square" alt="ddns-go">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/platform-linux%20%7C%20arm-lightgrey?style=flat-square" alt="Platform">
</p>

> 🚀 一键部署 [ddns-go][ddns-go] — 自动检测 CPU 架构，下载最新版本并注册为系统服务。安装后可通过 `ddns` 命令随时查看访问地址

---

## 📋 目录

- [快速安装](#-快速安装)
- [使用说明](#-使用说明)

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

安装完成后，脚本会自动安装 `ddns` 命令并显示服务器 IP。

```bash
# 随时查看访问地址
ddns
```

通过浏览器访问进行配置：

> 首次访问会进入初始化配置页面，需填写 DNS 服务商凭证（支持阿里云、腾讯云、Cloudflare、华为云等）和需要解析的域名。

**默认配置：**

| 参数 | 值 | 说明 |
|------|-----|------|
| 检查间隔 | `10 秒` | 每 10 秒检查一次 IP 变化 |
| 缓存时间 | `360 分钟` | DNS 记录缓存时间 |
| 配置文件 | `/opt/ddns-go/.ddns_go_config.yaml` | 配置文件路径 |

---

[ddns-go]: https://github.com/jeessy2/ddns-go
