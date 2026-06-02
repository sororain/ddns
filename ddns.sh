#!/bin/bash
set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[信息]${NC} $1"; }
warn()  { echo -e "${YELLOW}[警告]${NC} $1"; }
error() { echo -e "${RED}[错误]${NC} $1"; }

# 信号清理（Ctrl+C 时自动清理临时目录）
TMP_DIR=""
cleanup() {
  cd /
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
    info "已清理临时文件"
  fi
}
trap cleanup EXIT INT TERM

# Root 权限检测
if [ "$(id -u)" -ne 0 ]; then
  error "请以 root 用户或使用 sudo 运行此脚本"
  exit 1
fi

# 检查 curl，不存在则自动安装
if ! command -v curl &>/dev/null; then
  warn "未检测到 curl，尝试自动安装..."
  if command -v apt &>/dev/null; then
    apt update && apt install -y curl
  elif command -v yum &>/dev/null; then
    yum install -y curl
  elif command -v apk &>/dev/null; then
    apk add curl
  else
    error "无法自动安装 curl，请手动安装后重试"
    exit 1
  fi
fi

# 停止旧服务（允许失败）
systemctl stop ddns-go 2>/dev/null || true
rm -f /usr/bin/ddns-go

# 检测 CPU 架构
ARCH=$(uname -m)
case "$ARCH" in
  aarch64|arm64)
    oarch="linux_arm64"
    ;;
  armv7l|armv7)
    oarch="linux_armv7"
    ;;
  x86_64|amd64)
    oarch="linux_x86_64"
    ;;
  i386|i686)
    oarch="linux_x86_32"
    ;;
  *)
    error "不支持的 CPU 架构: $ARCH"
    exit 1
    ;;
esac
info "检测到架构: $ARCH → $oarch"

# 在临时目录工作
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
info "工作目录: $TMP_DIR"

# 获取最新版下载地址
info "获取最新版本信息..."
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/jeessy2/ddns-go/releases/latest | grep -i "browser_download_url.*${oarch}" | awk -F '"' '{print $(NF-1)}')

if [ -z "$DOWNLOAD_URL" ]; then
  error "获取下载地址失败，请检查网络连接"
  exit 1
fi

# 版本对比，已是最新则跳过
LATEST_TAG=$(curl -s https://api.github.com/repos/jeessy2/ddns-go/releases/latest | grep '"tag_name"' | awk -F '"' '{print $4}')
if command -v /usr/bin/ddns-go &>/dev/null; then
  LOCAL_VER=$(/usr/bin/ddns-go -version 2>/dev/null | grep -oP 'v?\d+\.\d+\.\d+' | head -1 || echo "")
  if [ -n "$LOCAL_VER" ] && [ "$LOCAL_VER" = "$LATEST_TAG" ]; then
    info "当前已是最新版本 ($LOCAL_VER)，跳过安装"
    exit 0
  fi
fi

# 下载
info "下载 ddns-go (${oarch})..."
if command -v wget &>/dev/null; then
  wget -q "$DOWNLOAD_URL" -O ddns.tar.gz
else
  curl -sL "$DOWNLOAD_URL" -o ddns.tar.gz
fi

# 解压安装
info "解压安装..."
tar -xzf ddns.tar.gz
chmod +x ddns-go
mv ddns-go /usr/bin/ddns-go
cd /
rm -rf "$TMP_DIR"

# 确保配置目录存在
mkdir -p /opt/ddns-go

# 注册系统服务
if ! systemctl is-enabled ddns-go &>/dev/null 2>&1; then
  info "注册系统服务..."
  ddns-go -s install -f 10 -cacheTimes 360 -c /opt/ddns-go/.ddns_go_config.yaml
else
  info "服务已注册，跳过安装步骤"
fi

# 启动服务
info "启动服务..."
systemctl start ddns-go
systemctl enable ddns-go

echo ""
info "======================================"
info "  ddns-go 安装/更新完成！"
info "  请访问 http://<本机IP>:9876 进行配置"
info "======================================"
