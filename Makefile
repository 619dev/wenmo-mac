SHELL := /bin/zsh
BUILD := .build
BUNDLE := $(BUILD)/问墨.app
CONTENTS := $(BUNDLE)/Contents
SOURCES := $(wildcard Sources/WenmoInputMethod/*.swift)
LICENSES := LICENSE NOTICE DATA-LICENSES.md Resources/licenses/CC-BY-SA-4.0.txt Resources/licenses/UNICODE-LICENSE.txt
SWIFTC := xcrun swiftc -module-cache-path "$(abspath $(BUILD))/ModuleCache"

.PHONY: all clean install uninstall test
all: $(BUNDLE)

$(BUNDLE): $(SOURCES) Resources/Info.plist Resources/AppIcon.icns Resources/cedict_pinyin.tsv $(LICENSES)
	mkdir -p "$(CONTENTS)/MacOS" "$(CONTENTS)/Resources"
	$(SWIFTC) -parse-as-library -O -framework AppKit -framework InputMethodKit \
		$(SOURCES) -o "$(CONTENTS)/MacOS/WenmoInputMethod"
	cp Resources/Info.plist "$(CONTENTS)/Info.plist"
	cp Resources/AppIcon.icns "$(CONTENTS)/Resources/AppIcon.icns"
	cp Resources/cedict_pinyin.tsv "$(CONTENTS)/Resources/cedict_pinyin.tsv"
	mkdir -p "$(CONTENTS)/Resources/licenses"
	cp LICENSE NOTICE DATA-LICENSES.md "$(CONTENTS)/Resources/licenses/"
	cp Resources/licenses/*.txt "$(CONTENTS)/Resources/licenses/"
	codesign --force --deep --sign - "$(BUNDLE)"

test:
	mkdir -p "$(BUILD)/ModuleCache"
	$(SWIFTC) -typecheck -parse-as-library -framework AppKit -framework InputMethodKit $(SOURCES)

install: $(BUNDLE)
	mkdir -p "$(HOME)/Library/Input Methods"
	ditto "$(BUNDLE)" "$(HOME)/Library/Input Methods/问墨.app"
	@echo "已安装。请退出登录后，在 系统设置 → 键盘 → 文本输入 → 编辑 中添加问墨。"

uninstall:
	rm -rf "$(HOME)/Library/Input Methods/问墨.app"

clean:
	rm -rf "$(BUILD)"
