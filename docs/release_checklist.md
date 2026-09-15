# 毕方开源发布清单

发布唯一来源是仓库根目录。发布前运行：

```powershell
.\scripts\release-v0.3.8.ps1
.\scripts\release-v0.3.8.ps1 -Build
```

脚本会确认：

1. README 与 CHANGELOG 都是当前发布版本；
2. 17 个公开 skill 均有 `SKILL.md`，并位于 `skills/core`、`skills/advanced` 或 `skills/legacy`；
3. Windows/macOS 安装与校验脚本都列出全部公开模块；
4. 发布包不包含 `.git`、`internal`、`private` 路径；
5. 压缩包名称与版本一致。

构建后必须在干净的 skills 目录各运行一次：

```powershell
.\install.ps1 -Destination <空目录>
.\validate-install.ps1 -Destination <空目录>
.\install.ps1 -All -Destination <另一空目录>
.\validate-install.ps1 -All -Destination <另一空目录>
```

手动安装检查：默认只复制 `bifang` 目录，确认它含有 `SKILL.md`；全量安装再检查 `bifang-clip`、`bifang-account-plan`、`bifang-evidence`。
