#!/bin/sh

PATH_XCODE=/Applications/Xcode.app
CURRENT_DIR=$(
    cd $(dirname $0)
    pwd
)
PATH_PROJ="${CURRENT_DIR}/.."
FILE_SPACE=XMApp.xcworkspace
FILE_TMP=moon__proj_tmp
FILE_SELECTED=moon__proj_selected
FILE_RESULT="${PATH_PROJ}/${FILE_SPACE}/contents.xcworkspacedata"

addAllProj() {
    osascript -e "tell app \"${PATH_XCODE}\" to quit"

    find ${PATH_PROJ} -name "*.xcodeproj" >${FILE_TMP}

    ./update_sub_proj.sh

    rm ${FILE_TMP}

    open ${PATH_PROJ}/${FILE_SPACE}
}

removeAllProj() {
    osascript -e "tell app \"${PATH_XCODE}\" to quit"

    find ${PATH_PROJ} -name "XMApp.xcodeproj" -or -name "Pods.xcodeproj" >${FILE_TMP}

    ./update_sub_proj.sh

    rm ${FILE_TMP}

    open ${PATH_PROJ}/${FILE_SPACE}
}

chooseSubProj() {
    osascript -e "tell app \"${PATH_XCODE}\" to quit"

    find ${PATH_PROJ} -name "*.xcodeproj" >${FILE_TMP}

    menuItems=""
    for path in $(cat ${FILE_TMP}); do
        if [ -e ${path} ]; then
            name=$(basename ${path} .xcodeproj)
            menuItems+="${name} "
        fi
    done
    
    $(osascript choose_sub_proj.applescript ${menuItems})
}

fastXcodegen() {
    find ${PATH_PROJ} -name "project.yml" >${FILE_TMP}

    for path in $(cat ${FILE_TMP}); do
        if [ -e ${path} ]; then
            p=${path%/*}
            cd $p
            xcodegen
        fi
    done

    cd ${CURRENT_DIR}
    rm ${FILE_TMP}
}

showMenu() {
    echo """
    ====== 使用教程 ======
    * Hints
    ** 查找所有的 .xcodeproj 文件并强行加入 .workspace 中

    * Optional
    ** Xcode 会自动重启
    ** 如果出现 .workspace 无法打开，可利用 pod install 还原

    ====== 菜单 ======
    1> 导入所有 .xcodeproj
    2> 删除其他 .xcodeproj
    3> 选择要加入并编译的 .xcodeproj
    4> 执行工程内所有 xcodegen
    0> 退出

    """
}

showMenu
while read -p "输入数字 + Enter 选择菜单：" idx; do
    if [[ ${idx} == "0" ]]; then
        break
    elif [[ ${idx} == "1" ]]; then
        addAllProj
    elif [[ ${idx} == "2" ]]; then
        removeAllProj
    elif [[ ${idx} == "3" ]]; then
        chooseSubProj
    elif [[ ${idx} == "4" ]]; then
        fastXcodegen
    else
        showMenu
    fi
done
