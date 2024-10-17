#!/bin/sh

fire_sync() {
  echo $(date)

  cd $workflow_path
  git add .
  git commit . -m 'daily sync with script'
  git pull --ff
  git push

  cd $blog_path
  if [[ -z $(git status -s) ]]; then
    echo "${blog_path} is clear."
  else
    git add .
    git commit . -m 'daily sync with script'
    git pull --ff
    git push

    # mkdocs
    source ~/venv3.12/bin/activate
    mkdocs gh-deploy
    deactivate
  fi

  cd $kit_path
  if [[ -z $(git status -s) ]]; then
    echo "${blog_path} is clear."
  else
    git checkout main;
    # ensure jazzy build correct
    xcodegen;
    git add .;
    git commit . -m 'daily sync with script';
    git pull --ff;
    git push;
    jazzy \
      --clean \
      --author darkThanBlack \
      --author_url https://darkthanblack.github.io \
      --source-host github \
      --source-host-url https://github.com/darkThanBlack/DTBKit \
      --exclude "Sources/Chain/*" \
      --output docs \
      --theme apple;
    mv docs ~/Documents/docs;
    git checkout gh-pages;
    git pull --ff;
    mv ~/Documents/docs ./;
    rm -rf ~/Documents/docs;
    git add .;
    git commit . -m 'deploy from jazzy';
    git push;
    git checkout main
  fi
}

fire() {
  if [[ $1 == "1" ]]; then
    workflow_path="/Users/xuyiding/Documents/iOS/MOONWorkflow"
    blog_path="/Users/xuyiding/Documents/iOS/darkThanBlack.github.io"
    kit_path="/Users/xuyiding/Documents/iOS/DTBKit"

    # 参照 jenkins 脚本，强行指定环境变量
    PATH=/Users/xuyiding/.rvm/gems/ruby-3.0.0/bin:/Users/xuyiding/.rvm/gems/ruby-3.0.0@global/bin:/Users/xuyiding/.rvm/rubies/ruby-3.0.0/bin:/Users/xuyiding/opt/anaconda3/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/xuyiding/flutter/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Users/xuyiding/.pub-cache/bin:/Users/xuyiding/.rvm/bin

    source /etc/profile
    source /Users/xuyiding/.zshrc
    # 触发 rvm 设置脚本
    source /Users/xuyiding/.bash_profile

    fire_sync
  fi
}

show_menu() {
  echo """
0> 退出

====== 菜单 ======
我在哪台电脑上?
1>xm-mbp
2>home-mbp
3>home_pc
4>xm-mac_studio
"""
}

if [[ ! $1 ]]; then
  show_menu
  while read -p "请选择> " idx; do
    if [[ ${idx} == "0" ]]; then
      exit 0
    else
      fire $idx
    fi
  done
else
  fire $1
fi
