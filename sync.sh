#!/bin/sh
workflow_path=""
blog_path=""
kit_path=""

fire_sync() {
  read -p "开始同步? y/N" ensure;
  if [[ ${ensure} == "y" ]]; then
    cd $workflow_path
    git add .
    git commit . -m 'daily sync with script'
    git pull --ff
    git push

    cd $blog_path
    git add .
    git commit . -m 'daily sync with script'
    git pull --ff
    git push
    source ~/venv3.12/bin/activate
    mkdocs gh-deploy
    deactivate

    cd $kit_path
    git add .
    git commit . -m 'daily sync with script'
    git pull --ff
    git push
  fi
}

show_menu() {
    echo """
0> 退出
Enter 重新打印

====== 菜单 ======
我在哪台电脑上?
1>xm-mbp
2>home-mbp
3>home_pc
4>xm-mac_studio
"""
}

show_menu
while read -p "请选择> " idx; do
    if [[ ${idx} == "0" ]]; then
      exit 0
    elif [[ ${idx} == "1" ]]; then
      workflow_path="~/Documents/iOS/MOONWorkflow"
      blog_path="~/Documents/iOS/darkThanBlack.github.io"
      kit_path="~/Documents/iOS/DTBKit"
      fire_sync
    else
      show_menu
    fi
done
