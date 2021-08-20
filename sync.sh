#!/bin/sh

# SHELL_FOLDER=$(
#   cd "$(dirname "$0")"
#   pwd
# )

SHELL_FOLDER="/Users/xuyiding/Documents/XiaoMai/b-ka-chain"

PATH_PROJ="/Users/xuyiding/Documents/XiaoMai/b-ka-chain"

FILE_TMP=moon_tmp

# result=$(osascript test.applescript)

find ${PATH_PROJ} -name "*.xcodeproj" >${FILE_TMP}

menuItems=""

for path in $(cat ${FILE_TMP}); do
  if [ -e ${path} ]; then
    # p=${path%/*}
    # echo "path=${path}"
    name=$(basename ${path} .xcodeproj)
    menuItems+="${name} "
    # cd $p
    # xcodegen
  fi
done
echo $menuItems
# https://stackoverflow.com/questions/16966117
result=`osascript test.applescript ${menuItems}`
echo "get result"
# https://www.jianshu.com/p/47cfd835b35d
# result=$(osascript <<EOF
# tell application "Xcode"
# 	set v to version ≤ "12.5.0"
# end tell
# get v
# EOF
# )

# if [[ "${result}" != "true" ]]; then
#   echo "警告：当前应用版本过高，可能出现适配问题"
# fi

# echo $result
