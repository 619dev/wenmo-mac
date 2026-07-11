SHELL := /bin/zsh
BUILD := .build
BUNDLE := $(BUILD)/问墨.app
DMG := $(BUILD)/问墨-1.0.6-macOS.dmg
DMG_ROOT := $(BUILD)/dmg-root
PKG := $(BUILD)/问墨-1.0.6-macOS.pkg
PKG_ROOT := $(BUILD)/pkg-root
COMPONENT_PKG := $(BUILD)/问墨-component.pkg
CONTENTS := $(BUNDLE)/Contents
SOURCES := $(wildcard Sources/WenmoInputMethod/*.swift)
LICENSES := LICENSE NOTICE DATA-LICENSES.md Resources/licenses/CC-BY-SA-4.0.txt Resources/licenses/UNICODE-LICENSE.txt
SWIFTC := xcrun swiftc -module-cache-path "$(abspath $(BUILD))/ModuleCache" -target arm64-apple-macos13.0
CODE_SIGN_IDENTITY ?= 8639D4B255BAD20EF7255A013529FCAB036DBF77

.PHONY: all clean dmg pkg install uninstall test sign
all: $(BUNDLE)

$(BUNDLE): $(SOURCES) Resources/Info.plist Resources/AppIcon.icns Resources/cedict_pinyin.tsv $(wildcard Resources/*.lproj/InfoPlist.strings) $(LICENSES)
	mkdir -p "$(CONTENTS)/MacOS" "$(CONTENTS)/Resources"
	$(SWIFTC) -parse-as-library -O -framework AppKit -framework InputMethodKit \
		-framework Carbon \
		$(SOURCES) -o "$(CONTENTS)/MacOS/WenmoInputMethod"
	cp Resources/Info.plist "$(CONTENTS)/Info.plist"
	cp Resources/AppIcon.icns "$(CONTENTS)/Resources/AppIcon.icns"
	cp Resources/cedict_pinyin.tsv "$(CONTENTS)/Resources/cedict_pinyin.tsv"
	for strings in Resources/*.lproj/InfoPlist.strings; do \
		lproj=$$(basename $$(dirname "$$strings")); \
		mkdir -p "$(CONTENTS)/Resources/$$lproj"; \
		cp "$$strings" "$(CONTENTS)/Resources/$$lproj/InfoPlist.strings"; \
	done
	mkdir -p "$(CONTENTS)/Resources/licenses"
	cp LICENSE NOTICE DATA-LICENSES.md "$(CONTENTS)/Resources/licenses/"
	cp Resources/licenses/*.txt "$(CONTENTS)/Resources/licenses/"
	find "$(BUNDLE)" -name '._*' -delete
	$(MAKE) sign

sign:
	find "$(BUNDLE)" -name '._*' -delete
	codesign --force --deep --options runtime --timestamp \
		--entitlements Resources/WenmoInputMethod.entitlements \
		--sign "$(CODE_SIGN_IDENTITY)" "$(BUNDLE)"
	codesign --verify --deep --strict --verbose=2 "$(BUNDLE)"

test:
	mkdir -p "$(BUILD)/ModuleCache"
	$(SWIFTC) -typecheck -parse-as-library -framework AppKit -framework InputMethodKit -framework Carbon $(SOURCES)

dmg: $(BUNDLE) DMG安装说明.txt
	rm -rf "$(DMG_ROOT)" "$(DMG)"
	mkdir -p "$(DMG_ROOT)"
	ditto --norsrc "$(BUNDLE)" "$(DMG_ROOT)/问墨.app"
	cp DMG安装说明.txt "$(DMG_ROOT)/安装说明.txt"
	hdiutil create -volname "问墨输入法 1.0.6" -srcfolder "$(DMG_ROOT)" \
		-ov -format UDZO "$(DMG)"
	@echo "DMG 已生成：$(DMG)"

pkg: $(BUNDLE) package/Wenmo-component.plist scripts/preinstall scripts/postinstall
	$(MAKE) sign
	rm -rf "$(PKG_ROOT)" "$(COMPONENT_PKG)" "$(PKG)"
	mkdir -p "$(PKG_ROOT)"
	ditto --norsrc "$(BUNDLE)" "$(PKG_ROOT)/问墨.app"
	chmod +x scripts/preinstall scripts/postinstall
	pkgbuild --root "$(PKG_ROOT)" \
		--component-plist package/Wenmo-component.plist \
		--identifier com.fm619.wenmo.inputmethod.Wenmo \
		--version 1.0.6 \
		--install-location "/Library/Input Methods" \
		--scripts scripts "$(COMPONENT_PKG)"
	productbuild --package "$(COMPONENT_PKG)" "$(PKG)"
	@echo "PKG 已生成：$(PKG)"

install: $(BUNDLE)
	sudo mkdir -p "/Library/Input Methods"
	sudo ditto --norsrc "$(BUNDLE)" "/Library/Input Methods/问墨.app"
	"/Library/Input Methods/问墨.app/Contents/MacOS/WenmoInputMethod" --register-input-source
	"/Library/Input Methods/问墨.app/Contents/MacOS/WenmoInputMethod" --enable-input-source
	-"/Library/Input Methods/问墨.app/Contents/MacOS/WenmoInputMethod" --select-input-source
	@echo "已安装、注册并启用问墨输入法；如未自动切换，请从输入法菜单选择问墨。"

uninstall:
	sudo rm -rf "/Library/Input Methods/问墨.app" "/Library/Input Library/问墨.app"

clean:
	rm -rf "$(BUILD)"
