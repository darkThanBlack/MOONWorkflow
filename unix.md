# *.sh



## Linux

```shell
ls ~/.ssh/
ssh-keygen -t ed25519 -C "your_email@example.com"

git config --global --add user.name "user_name"
git config --global --add user.email "user_email@qq.com"

git clone --depth 1 --branch master git@github.com:darkThanBlack/MOONWorkflow.git

# Ubuntu
sudo apt update
sudo apt-get update
# -y: 自动确认
sudo apt install -y unzip

# 系统自启动服务
ls /etc/systemd/system
vi /etc/systemd/system/name.service
vi /etc/systemd/system/name\@.service
systemctl status name
systemctl enable name.service
systemctl start name.service
systemctl stop name
# 启停后需要状态刷新
systemctl daemon-reload
systemctl restart name
systemctl reset-failed name

# 端口
ss -tulpn | grep 11010
iptables -L | grep 5001
ssh -L 5001:localhost:5001 root@YOUR_SERVER_IP
# https://www.yougetsignal.com/tools/open-ports/

# 代理连通性测试
curl --socks5 10.144.144.1:1080 -I https://www.google.com

# 当前网卡
ip a

# 如果要动 iptables 规则，先用这个备份
# netfilter-persistent save
# /etc/iptables/rules.v4
```



```shell
# ss client
sudo apt install -y shadowsocks-libev

systemctl status | grep shadow

vi /etc/shadowsocks-libev/client.json
{
    "server": "45.76.202.191",
    "server_port": 17999,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "My",
    "timeout": 300,
    "method": "aes-256-gcm"
}
```



```shell
# proxychains4, 代理当前命令
sudo apt install -y proxychains4
# e.g
sudo proxychains4 docker compose up -d

vi /etc/proxychains4.conf
# 要修改的
dynamic_chain

[ProxyList]
socks5 127.0.0.1 1080
```



```shell
# Docker
# 卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
# 安装依赖
# ca-certificates curl: SSL 证书安全下载
# gnupg: 加密签名验证
# lsb-release: 系统版本信息
sudo apt-get install -y ca-certificates curl gnupg lsb-release
# 创建目录，权限设为 755（可读写执行）
sudo install -m 0755 -d /etc/apt/keyrings
# 下载 Docker 官方的公钥文件, 转换密钥格式, 保存到新位置
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# 设为可读权限
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# $(dpkg --print-architecture): CPU 架构
# signed-by=/etc/apt/keyrings/docker.gpg: 用刚才下载的密钥验证软件包
# https://download.docker.com/linux/ubuntu: Docker 官方的 Ubuntu 软件仓库
# $(. /etc/os-release && echo "$VERSION_CODENAME"): 自动获取你的 Ubuntu 版本代号（如 jammy）
# stable: 稳定版
# sudo tee: 把内容写入文件，同时显示在屏幕
# /etc/apt/sources.list.d/docker.list: 存放前面设置的这些内容
# /dev/null: 隐藏输出
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# 真正安装
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# 验证
sudo docker --version
sudo docker run hello-world

# 如果能确定本地代理运行正常
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf << 'EOF'
[Service]
Environment="HTTP_PROXY=socks5://10.144.144.1:1080"
Environment="HTTPS_PROXY=socks5://10.144.144.1:1080"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

# docker compose 无法由 proxychains4 劫持，还是需要镜像
vi /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://docker.1panel.live",
    "https://hub.rat.dev",
    "https://docker.mirrors.ustc.edu.cn",
    "https://docker.nju.edu.cn",
    "https://docker.mirrors.sjtug.sjtu.edu.cn",
    "https://docker.mirrors.aliyun.com",
    "https://dockerpull.org",
    "https://docker.1ms.run",
    "https://docker.m.daocloud.io"
  ]
}
# 重启服务
sudo systemctl daemon-reload
sudo systemctl restart docker
# 验证镜像配置生效
docker info | grep -A 5 "Registry Mirrors"

# e.g. compose 需要进入到对应目录
cd /opt/dockge
docker compose down
docker compose up -d
# 查看容器运行状态
docker ps | grep dockge
```



```shell
# Dockage
sudo mkdir -p /opt/dockge/stacks
cd /opt/dockge
sudo tee compose.yaml << 'EOF'
version: "3.8"
services:
  dockge:
    image: louislam/dockge:1
    restart: unless-stopped
    ports:
      # 不填的话对外开放
      - 127.0.0.1:5001:5001
      - 10.114.114.2:5001:5001
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      - ./stacks:/opt/stacks
    environment:
      - DOCKGE_STACKS_DIR=/opt/stacks
EOF
```



```shell
# Easytier
# https://easytier.cn/guide/network/configurations.html

wget -O easytier.sh "https://raw.githubusercontent.com/EasyTier/EasyTier/main/script/install.sh" && sudo bash easytier.sh install --gh-proxy https://ghfast.top/

# 先停止并删除默认服务
systemctl status easytier@default
# 再创建自定义服务, ExecStart 是配置文件路径
vi /etc/systemd/system/easytier.service
[Unit]
After=network.target syslog.target
Description=A full meshed p2p VPN, connecting all your devices in one network with one command.
[Service]
Type=simple
WorkingDirectory=/tmp
ExecStart=/opt/easytier/easytier-core -c /root/et_config.toml
Restart=on-failure
RestartSec=1
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target

# 配置文件字段通过运行 easytier-core 后直接查看当前输出得到
vi /root/et_config.toml
instance_name = "xm-mbp"
hostname = "xm-mbp"
dhcp=true
# ipv4 = "10.114.114.2"
listeners = [
    "tcp://0.0.0.0:11010",
    "udp://0.0.0.0:11010",
    "wg://0.0.0.0:11011",
    "ws://0.0.0.0:11011",
    "wss://0.0.0.0:11012",
]
exit_nodes = []
rpc_portal = "0.0.0.0:0"

[[peer]]
uri = "udp://45.76.202.191:11010"
[[peer]]
uri = "wss://45.76.202.191:11012"
[[peer]]
uri = "tcp://45.76.202.191:11010"
[[peer]]
uri = "wg://45.76.202.191:11011"
[[peer]]
uri = "ws://45.76.202.191:11011"

[network_identity]
network_name = "moon_easytier"
network_secret = "My"

[flags]
default_protocol = "udp"
dev_name = ""
enable_encryption = true
enable_ipv6 = true
mtu = 1380
latency_first = false
enable_exit_node = false
no_tun = false
use_smoltcp = false
foreign_network_whitelist = "*"
disable_p2p = false
p2p_only = false
relay_all_peer_rpc = false
disable_tcp_hole_punching = false
disable_udp_hole_punching = false

```




## Mac OS

* ``~/.ShadowsocksX-NG/user-rule.txt``
* ``~/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist``

```shell
# 任何来源
sudo spctl --master-disable

# Content 内容变化后报错
sudo xattr -rd com.apple.quarantine /Applications/*.app

# 重签名
sudo xattr -cr /Applications/Sketch.app
sudo codesign --force --deep --sign /Applications/Sketch.app

# launchctl 相当于 systemctl, 通过 plist 管理
ls ~/Library/LaunchAgents
cp ~/Documents/iOS/MOONWorkflow/moonShadow.github.sync.plist ~/Library/LaunchAgents
sudo launchctl load /Users/xuyiding/Library/LaunchAgents/moonShadow.github.sync.plist
launchctl start /Users/xuyiding/Library/LaunchAgents/moonShadow.github.sync.plist
launchctl unload /Users/xuyiding/Library/LaunchAgents/moonShadow.github.sync.plist
launchctl list | grep moonShadow

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

brew install xcodegen

# ERROR
fatal: cannot create directory at 'Library/Homebrew/vendor/bundle/ruby/3.4.0/gems/base64-0.3.0': Permission denied
# FIX
# 修复 Homebrew 目录的所有权
sudo chown -R $(whoami) $(brew --prefix)
# 如果上面命令报错，试试这个
sudo chown -R $(whoami) /opt/homebrew
# 或者对于 Intel Mac
sudo chown -R $(whoami) /usr/local/Homebrew


# ERROR
<internal:/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.4.4/lib/ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:37:in 'Kernel#require': cannot load such file -- sorbet-runtime (LoadError)
	from <internal:/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.4.4/lib/ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:37:in 'Kernel#require'

# FIX
# 检查 git 连通性
cd /opt/homebrew
git fetch origin
# 这个是重装 ruby 独立环境
rm -rf /opt/homebrew/Library/Homebrew/vendor
brew update --force

# RVM
\curl -sSL https://get.rvm.io | bash -s stable

# 同时尝试安装 ruby
\curl -sSL https://get.rvm.io | bash -s stable --rails
# 或
rvm list known
rvm install 3.0.0 --disable-binary

rvm list
rvm use 3.0.0 --default
which ruby

# GEM
ruby --version  # 3.0.0
gem --version  # 3.2.3

# 删除
gem list | cut -d " " -f1 | xargs sudo gem uninstall -aIx

gem search cocoapods
gem install cocoapods -v 1.15.2

# NVM
# https://www.runoob.com/w3cnote/nvm-manager-node-versions.html
brew install nvm

Please note that upstream has asked us to make explicit managing
nvm via Homebrew is unsupported by them and you should check any
problems against the standard nvm install method prior to reporting.

You should create NVM's working directory if it doesn't exist:
  mkdir ~/.nvm

Add the following to your shell profile e.g. ~/.profile or ~/.zshrc:


export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

You can set $NVM_DIR to any location, but leaving it unchanged from
/opt/homebrew/Cellar/nvm/0.40.3 will destroy any nvm-installed Node installations
upon upgrade/reinstall.

Type `nvm help` for further information.

# cd web project
nvm install --lts
nvm use --lts
```



## Claude Code

[Website](https://docs.claude.com/en/docs/claude-code/quickstart#native-install)

`````shell
npm install -g @anthropic-ai/claude-code
# or
curl -fsSL https://claude.ai/install.sh | bash

# Proj/.claude/settings.local.json
{
  "permissions": {
    "defaultMode": "bypassPermissions"
  }
}
`````



## CCR

[Link](https://github.com/musistudio/claude-code-router)

```shell
npm install -g @musistudio/claude-code-router

ccr status / start / ui / code
```

重点在于 api_base_url 的 v1 后缀需要和实际的提供服务对应上，否则就得用 transformer 

`````json
{
  "LOG": false,
  "LOG_LEVEL": "debug",
  "CLAUDE_PATH": "",
  "HOST": "127.0.0.1",
  "PORT": 3456,
  "APIKEY": "",
  "API_TIMEOUT_MS": "600000",
  "PROXY_URL": "",
  "transformers": [],
  "Providers": [
    {
      "name": "Claude",
      "api_base_url": "https://llm.ixm5.cn/v1/messages",
      "api_key": "sk-",
      "models": [
        "claude-sonnet-4-20250514"
      ],
      "transformer": {
        "use": [
          "Anthropic"
        ]
      }
    }
  ],
  "StatusLine": {
    "enabled": false,
    "currentStyle": "default",
    "default": {
      "modules": []
    },
    "powerline": {
      "modules": []
    }
  },
  "Router": {
    "default": "Claude,claude-sonnet-4-20250514",
    "background": "Claude,claude-sonnet-4-20250514",
    "think": "Claude,claude-sonnet-4-20250514",
    "longContext": "Claude,claude-sonnet-4-20250514",
    "longContextThreshold": 60000,
    "webSearch": "Claude,claude-sonnet-4-20250514",
    "image": "Claude,claude-sonnet-4-20250514"
  },
  "CUSTOM_ROUTER_PATH": ""
}
`````



