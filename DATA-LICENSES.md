# 词库及数据许可证

仓库根目录的 Apache License 2.0 适用于问墨自行编写的源代码和项目文档，不适用于另有说明的第三方数据。

## CC-CEDICT

- 内容：简体词形、繁体词形、汉语拼音及英文释义
- 项目：https://cc-cedict.org/
- 获取日期：2026-07-10
- 许可证：Creative Commons Attribution-ShareAlike 4.0 International
- 许可证副本：`Resources/licenses/CC-BY-SA-4.0.txt`
- 本项目用途：生成离线拼音到简繁词形索引
- 派生数据：`Resources/cedict_pinyin.tsv`

派生索引仅保留拼音、简体词形和繁体词形，移除了英文释义；生成过程还进行了格式规范化、按无声调拼音分组、面向输入法的候选排序，并限制每个拼音键的候选数量。

CC-CEDICT 及其派生词库数据不适用本项目代码的 Apache License 2.0，而继续依据 CC BY-SA 4.0 提供。再分发或修改该数据时，必须遵守署名和相同方式共享等条款。

## Unicode Unihan

- 内容：汉字属性；生成流程使用 `kGradeLevel` 辅助基础教育常用字排序
- 项目：https://www.unicode.org/reports/tr38/
- 获取日期：2026-07-10
- 许可证：Unicode License v3
- 许可证副本：`Resources/licenses/UNICODE-LICENSE.txt`

Unihan 数据未直接包含在本仓库的运行时词库中，但参与了派生索引的生成；相关版权和许可声明随派生制品保留。
