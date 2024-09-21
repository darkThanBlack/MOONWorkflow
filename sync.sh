#!/bin/sh

fire_sync() {
  echo $(date)

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
}

fire() {
  if [[ $1 == "1" ]]; then
      workflow_path="/Users/xuyiding/Documents/iOS/MOONWorkflow"
      blog_path="/Users/xuyiding/Documents/iOS/darkThanBlack.github.io"
      kit_path="/Users/xuyiding/Documents/iOS/DTBKit"
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

