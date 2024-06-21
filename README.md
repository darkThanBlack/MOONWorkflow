# 个人工作流



>  ~~安装包放在``packages``分支~~



## 拉取

```shell
$ git clone --depth 1 --branch master git@github.com:darkThanBlack/MOONWorkflow.git
```



## SS + KcpTun

* ``~/.ShadowsocksX-NG/user-rule.txt``
* ``~/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist``



## iTerm2

* [下载](https://iterm2.com/downloads.html)
* 个人设置同步：``Preferences -> General -> Settings -> Load settings from a custom folder or URL``



## Karabiner

* [下载](https://karabiner-elements.pqrs.org/) 或 [GitHub](https://github.com/pqrs-org/Karabiner-Elements/releases)
* 个人设置同步
  * ``Setting -> Misc -> Open config folder``
  * ``~/.config/karabiner``



## Alfred

* [下载](https://macked.app/alfred.html)
* 访问权限：完全磁盘访问权限
* 个人设置同步：``Advanced -> Syncing``
* 应用搜索：``Features -> Search Scope`` 添加 ``Applications``



## Typora

* [中文官网下载](https://typoraio.cn/)

* [英文官网下载](https://typora.io/)

* 破解：

  ```shell
  # 找到文件: /Applications/Typora.app/Contents/Resources/TypeMark/page-dist/static/js/LicenseIndex.180dd4c7.6d698c41.chunk.js
  # 检查字段: hasActivated="true"
  ```



## Xcode

* [单独安装模拟器环境](https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes)

  ```shell
  sudo xcode-select -s /Applications/Xcode-beta.app;
  sudo xcodebuild -runFirstLaunch;
  sudo xcrun simctl runtime add "~/Downloads/**.dmg"
  ```

  

* ``~/Library/Developer/Xcode/UserData``

  * CodeSnippets：代码片段
  * FontAndColorThemes：主题
  * KeyBindings：快捷键




## Snippets

* 固定前缀：``MOON``
* 片段文件名：OC 用``MOON__``开头，Swift 用``MOON_``开头以区分，快捷方式不变。
  * 新建文件：``MOON_New``
    * ``MOON_NewViewController``
    * ``MOON_NewView``
    * ``MOON_NewCell``
  * 对象声明：``MOON_GetLazy``
    * ``MOON_GetLazyUIView``
    * ``MOON_GetLazyUILabel``
    * ``MOON_GetLazyUIImageView``
    * ``MOON_GetLazyUIButton``
    * ``MOON_GetLazyUITableView``
  * 页面布局：``MOON_SnapKit``
  * 用户事件：``MOON_SingleTapGesture``



## PicGo

* [下载](https://picgo.github.io/PicGo-Doc/zh/guide/#%E4%B8%8B%E8%BD%BD%E5%AE%89%E8%A3%85)
* [打不开/打开黑屏](https://github.com/Molunerfinn/PicGo/issues/781#issuecomment-1008603421)
* ``~/Library/Application Support/picgo/data.json``



## Scripts

脚本备份
