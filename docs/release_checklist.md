# 毕方开源发布清单

发布唯一来源是仓库根目录。发布前运行：

```powershell
.\scripts\release-v0.3.5.ps1
.\scripts\release-v0.3.5.ps1 -Build
```

脚本会确认：

1. README 与 CHANGELOG 都是当前发布版本；
2. 16 个公开 skill 均有 `SKILL.md`；
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

手动安装检查：将 `bifang-clip`、`bifang-account-plan`、`bifang-evidence` 三个目录复制到 skills 目录，确认各自均有 `SKILL.md`。
