# 问墨输入法（macOS）

这是问墨 iOS 核心输入逻辑的 macOS `InputMethodKit` 移植版。它完全离线，复用同一份
CC-CEDICT 拼音词库，支持拼音组合、候选选择、空格上屏、退格、Esc 取消及简繁切换。

## 构建与安装

要求 macOS 13 或更新版本及 Xcode Command Line Tools。

```sh
make
make install
```

安装后退出并重新登录，然后前往“系统设置 → 键盘 → 文本输入 → 编辑”，在简体中文输入源中
添加“问墨”。输入拼音后使用空格选择首候选，也可从候选窗选择其他候选。输入法菜单可切换简繁。

开发时可运行 `make test` 做 Swift 类型检查。产物位于 `.build/问墨.app`。

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
