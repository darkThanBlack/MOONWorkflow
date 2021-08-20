#!/bin/sh

msg_dt="未知缓存："
PATH_DT=~/Library/Caches/com.apple.dt.Xcode
msg_derived="DerivedData："
PATH_DERIVED=~/Library/Developer/Xcode/DerivedData
msg_pgd="playground_derivedData："
PATH_PGD=~/Library/Developer/XCPGDevices
msg_simulator_cache="模拟器缓存："
PATH_SIMULATOR_CACHE=~/Library/Developer/CoreSimulator/Caches
msg_icon="APP_ICON_缓存："
PATH_ICON=~/Library/Developer/Xcode/Products

safe_dirs_msgs=($msg_dt $msg_derived $msg_pgd $msg_simulator_cache $msg_icon)
safe_dirs=($PATH_DT $PATH_DERIVED $PATH_PGD $PATH_SIMULATOR_CACHE $PATH_ICON)

msg_archive="打包记录与dSYM"
PATH_ARCHIVE=~/Library/Developer/Xcode/Archives
msg_device="iOS系统版本支持"
PATH_DEVICE=~/Library/Developer/Xcode/"iOS DeviceSupport"
msg_simulator="iOS模拟器支持"
PATH_SIMULATOR=~/Library/Developer/CoreSimulator/Devices

unsafe_dirs_msgs=($msg_archive $msg_device $msg_simulator)
unsafe_dirs=($PATH_ARCHIVE "$PATH_DEVICE" $PATH_SIMULATOR)

delSafeDir() {
    for i in ${!safe_dirs[@]}; do
        echo "${safe_dirs_msgs[$i]}"
        du -sh ${safe_dirs[$i]}
    done
    read -p "是否全部删除？(y/n)" answer
    case $answer in
        Y | y)
            for dir in ${safe_dirs[@]}; do
            rm -r $dir
            done
        ;;
        *)
            echo "操作取消，按Enter继续..."
        ;;
    esac
}

openUnsafeDir() {
    IFS="阿巴阿巴"
    for i in ${!unsafe_dirs[@]}; do
        echo "${unsafe_dirs_msgs[$i]}"
        du -sh "${unsafe_dirs[$i]}"
    done
    unset IFS
    read -p "是否打开对应文件夹？(y/n)" answer
    case "$answer" in
        Y | y)
            IFS="阿巴阿巴"
            for dir in ${unsafe_dirs[@]}; do
            open $dir
            done
            unset IFS
        ;;
        *)
            echo "操作取消，按Enter继续..."
        ;;
    esac
}

showMenu() {
    echo "1> 可删"
    echo "2> 选删"
    echo "0> exit"
}

showMenu

while read -p "MyXcode>>>" idx; do
    case "$idx" in
        1)
            delSafeDir
        ;;
        2)
            openUnsafeDir
        ;;
        0)
            exit 0
        ;;
        *)
            showMenu
        ;;
    esac
done
