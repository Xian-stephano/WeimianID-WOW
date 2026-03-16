# WeiMianID

`WeiMianID` 是一个《魔兽世界》插件，用于在鼠标指向 NPC 时显示当前位面编号（Phase ID），并根据战争模式状态以不同颜色显示结果。

## 功能特性

- 鼠标悬停 NPC 时，实时显示当前位面编号。
- 战争模式颜色区分：
  - **绿色**：PVE
  - **红色**：PVP（战争模式开启）
- 在目标提示（Tooltip）中显示 NPC 存活时间（仅 Creature/Vehicle）。
- 自动隐藏于宠物对战期间，结束后自动恢复显示。
- 支持拖动框体位置，并自动保存。
- 提供重置命令：`/wmreset`
- 内置不显示位面 ID 的 NPC 白名单。

## 安装方法

1. 下载本仓库代码。
2. 将插件目录放入：
   - `World of Warcraft/_retail_/Interface/AddOns/`
3. 确认目录结构类似：

```text
AddOns/
└── WeiMianID/
    ├── WeiMianid.toc
    ├── WeiMianID.lua
    └── README.md
```

4. 进入游戏，在角色选择界面勾选并启用 `WeiMianID`。

## 使用说明

1. 进入游戏后，将鼠标移动到任意 NPC 上。
2. 插件框体会显示当前位面编号。
3. 如果框体位置跑偏或丢失，输入以下命令重置：

```bash
/wmreset
```

## 颜色说明

- `|cff40ff40绿色数字|r`：当前为 PVE 位面。
- `|cffff4040红色数字|r`：当前为 PVP 位面（战争模式开启）。

## 兼容性

- TOC 接口版本：`120000`
- 适配版本以 `WeiMianid.toc` 中 `## Interface` 为准。

## 已知限制

- 仅在能获取到鼠标目标 GUID 时显示有效位面编号。
- 对战宠物（Pet）以及白名单 NPC 不显示位面编号。

## 作者

- 玻尔兹曼常数@末日行者-CN

## 许可证

当前仓库未声明许可证。如需开源分发，请补充 `LICENSE` 文件。
