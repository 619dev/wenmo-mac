# 问墨输入法（macOS）

这是问墨 iOS 核心输入逻辑的 macOS `InputMethodKit` 移植版。它完全离线，复用同一份
CC-CEDICT 拼音词库，支持拼音组合、候选选择、空格上屏、退格、Esc 取消及简繁切换。

## 使用 PKG 安装（推荐）

1. 双击 `问墨-1.0.6-macOS.pkg`。
2. 按系统安装器提示输入管理员密码并完成安装。
3. 安装器会把问墨部署到 macOS 标准目录 `/Library/Input Methods`，并尝试注册、启用和选择输入源。
4. 如果菜单没有立即刷新，请退出当前 macOS 账户并重新登录。

也可以把 app 手工拖到 `~/Library/Input Methods`。新增或更新输入法后，近期 macOS 通常需要
退出当前账户并重新登录，系统设置和输入法菜单才会刷新。

## 从源码构建与安装

要求 macOS 13 或更新版本及 Xcode Command Line Tools。

```sh
make
make pkg
make dmg
```

双击生成的 PKG 完成系统级安装。输入拼音后使用空格选择首候选，也可从候选窗选择其他候选。
输入法菜单可切换简繁。

开发时可运行 `make test` 做 Swift 类型检查。应用产物位于 `.build/问墨.app`，安装包位于
`.build/问墨-1.0.6-macOS.pkg`。

## 隐私

输入法不申请网络或录音权限，不包含遥测、广告、远程配置或在线词库。词库只读，组合内容仅
保存在当前输入法进程的内存中。

## 捐助

如果这个项目对你有用的话，请我喝罐可乐吧。
<br>
<img width=30% height=30% src="请我喝可乐.jpg" alt="qrcode">
<br>

## 开源许可

问墨自行编写的源代码和项目文档依据 [Apache License 2.0](LICENSE) 开放。离线词库
`Resources/cedict_pinyin.tsv` 是 CC-CEDICT 的派生数据，依据 CC BY-SA 4.0 提供；完整的
第三方来源、修改说明与许可边界见 [DATA-LICENSES.md](DATA-LICENSES.md) 和 [NOTICE](NOTICE)。
