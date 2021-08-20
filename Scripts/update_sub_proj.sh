#!/bin/sh

CURRENT_DIR=$(
    cd $(dirname $0)
    pwd
)
PATH_PROJ="${CURRENT_DIR}/.."
FILE_SPACE=XMApp.xcworkspace
FILE_TMP=moon__proj_tmp
FILE_SELECTED=moon__proj_selected
FILE_RESULT="${PATH_PROJ}/${FILE_SPACE}/contents.xcworkspacedata"

buildXml() {
    echo '<?xml version="1.0" encoding="UTF-8"?>' >${FILE_RESULT}
    echo '<Workspace version = "1.0">' >>${FILE_RESULT}

    for path in $(cat ${FILE_TMP}); do
        if [ -e ${path} ]; then
            loc=${path//${PATH_PROJ}/}
            loc=${loc:1}
            echo "<FileRef" >>${FILE_RESULT}
            echo "  location = \"group:${loc}\">" >>${FILE_RESULT}
            echo "</FileRef>" >>${FILE_RESULT}
        fi
    done

    echo "</Workspace>" >>${FILE_RESULT}
}

syncTempFile() {
    $(echo >${FILE_TMP})
    menuItems=""
    for name in $(cat ${FILE_SELECTED}); do
        echo $name
        if [ -n ${name} ]; then
            menuItems+="${name} "
            $(find ${PATH_PROJ} -name "${name}.xcodeproj" >>${FILE_TMP})
        fi
    done
    $(find ${PATH_PROJ} -name "XMApp.xcodeproj" -or -name "Pods.xcodeproj" >>${FILE_TMP})
    # 直接插参数不知道为什么不行，需要优化
    # $(find ${PATH_PROJ} -name "XMApp.xcodeproj" -or -name "Pods.xcodeproj" ${param}>${FILE_TMP})
    
    buildXml

    open ${PATH_PROJ}/${FILE_SPACE}
    
    $(osascript build_sub_proj.applescript ${menuItems})
}

if [[ $1 == "SYNC_NEEDED" ]]; then
    syncTempFile
else
    buildXml
fi
