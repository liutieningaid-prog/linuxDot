mkdir ~/.ssh
echo "# thinkbook.pub" > ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcyPDkNkkzMfm+yZYGN6jyxAY09xQV8rkngYd7TAlrs tom@tom.tom" >> ~/.ssh/authorized_keys

sudo apt update
sudo apt install --no-install-recommends --no-install-suggests stow fish curl wget git zoxide exa


##############
## Fish     ##
##############
git clone --depth=1 https://github.com/liutieningaid-prog/linuxDot.git ~/dotfiles
cd ~/dotfiles
stow vim
stow helix
rm ~/.config/fish/config.fish
stow fish


fish
fish_config theme choose Dracula
fish_config theme save

##############
## Eget     ##
##############

mkdir -p $HOME/.local/bin
cd $HOME/.local/bin

wget https://github.com/zyedidia/eget/releases/download/v1.3.4/eget-1.3.4-linux_amd64.tar.gz
tar -xf eget-1.3.4-linux_amd64.tar.gz
rm eget-1.3.4-linux_amd64.tar.gz
mv eget-1.3.4-linux_amd64/eget ./
rm eget-1.3.4-linux_amd64/ -r

mkdir -p ~/.config/eget
vim ~/.config/eget/eget.toml

"""
[global]
target = "~/.local/bin"

["anomalyco/opencode"]
upgrade_only = true
"""

./eget starship/starship
fish

eget Schniz/fnm
fnm install 24

eget oven-sh/bun
eget astral-sh/uv
eget atuinsh/atuin
eget anomalyco/opencode

##############
## opencode ##
##############

vim ~/.config/opencode/opencode.json

{
  "plugin": ["opencode-antigravity-auth@latest"]
}

opencode auth login


sudo vim /etc/systemd/system/opencode.service

"""
[Unit]
Description=OpenCode Web Service
After=network.target

[Service]
# 指定运行的用户和组
User=tom
Group=Users
# 如果需要指定补充组，可以取消下面这行的注释
# SupplementaryGroups=Users

# 设置工作目录
WorkingDirectory=/vol1/1000/00_home/Project

# 执行命令（建议使用 opencode 的绝对路径，可用 'which opencode' 查看）
ExecStart=/vol1/1000/00_home/.local/bin/opencode web --hostname 0.0.0.0 --port 10000

# 自动重启设置
Restart=always
RestartSec=5

# 环境变量（如果需要）
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
"""

sudo systemctl daemon-reload
sudo systemctl start opencode
sudo systemctl enable opencode

##############
## UV 全局  ##
##############

uv venv ~/.local/envPY --python 3.10
chmod +x ~/.local/envPY/bin/activate.fish
source ~/.local/envPY/bin/activate

##############
## claude   ##
##############


eget SaladDay/cc-switch-cli
npm install -g @anthropic-ai/claude-code
npm install -g @getpaseo/cli