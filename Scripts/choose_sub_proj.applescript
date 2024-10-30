
on showSelectMenu(argv)
  set file_selected to "moon__proj_selected"
  
  choose from list argv with prompt "请选择要添加的子工程名称" multiple selections allowed True
  if the result is not false then
    set res to the result
    -- 构建已选择工程名
    do shell script "echo " & ">" & file_selected
    repeat with i in res
      set proj_name to contents of i
      do shell script "echo " & proj_name & ">>" & file_selected
    end repeat
    delay 0.5
    do shell script "./update_sub_proj.sh SYNC_NEEDED"
  end if
end showSelectMenu

on run argv
  set message to "
  ===用途===
  自动化添加子工程

  ===必看===
  【先】：必须先在 Xcode 里选好要编译的【设备】！
  【不要选】:Runner，Pods 和 XMApp 不要选上，主工程会最后自动跑
  
  ===其他===
  【卡顿】:刚开始可能会有一个卡顿，先【不要乱动】，因为参数插入有问题，所以会短时间跑大量 find
  【键鼠操作】:最好不要对 Xcode 输入【键鼠操作】，运行过程中 Xcode 会自动重启，切换选项和编译
   上次选项记录在'moon__proj_selected'文件内，也可以手动改
  "
  set dialog_result to display dialog message with title "提示" buttons {"取消", "重新选择", "使用上次选中的"}
  if button returned of dialog_result is "重新选择" then
    showSelectMenu(argv)
  else if button returned of dialog_result is "使用上次选中的" then
    delay 0.5
    do shell script "./update_sub_proj.sh SYNC_NEEDED"
  end if
  
end run
