# 毕方安装说明

毕方是 Codex/Agent skills 目录包，不需要编译，也不需要安装依赖。安装动作就是把 `bifang-*` 文件夹复制到你的 skills 目录。

## Windows 一键安装

在仓库根目录打开 PowerShell：

```powershell
.\install.ps1
```

默认安装核心模块：

```text
bifang-starter
bifang-topic
bifang-script
bifang-review
bifang-rewrite
bifang-feedback
```

如果你要安装全部公开模块：

```powershell
.\install.ps1 -All
```

如果你的 skills 目录不是默认位置：

```powershell
.\install.ps1 -Destination "D:\your\skills"
```

## 手动安装

1. 找到你的 Codex skills 目录：

```text
C:\Users\你的用户名\.codex\skills
```

2. 把需要的 `bifang-*` 文件夹复制进去。

3. 重启 Codex 或新开一个会话。

4. 用这句话测试：

```text
用 bifang-starter 帮我看看：我开社区面馆，想拍抖音引流。
```

## 推荐安装组合

首次使用只装核心模块：

```text
bifang-starter
bifang-topic
bifang-script
bifang-review
bifang-rewrite
bifang-feedback
```

需要客户建档和交付报告，再加：

```text
bifang-intake
bifang-diagnosis
bifang-profile
bifang-assets
bifang-report
```

历史兼容入口可选：

```text
bifang-baokuan
bifang-baokuan-batch
```

## 安装检查

安装后确认目录类似这样：

```text
C:\Users\你的用户名\.codex\skills\bifang-starter\SKILL.md
C:\Users\你的用户名\.codex\skills\bifang-topic\SKILL.md
C:\Users\你的用户名\.codex\skills\bifang-script\SKILL.md
```

每个 skill 文件夹里必须有 `SKILL.md`。

## 常见问题

### 复制到哪里？

复制到你的 Agent/Codex skills 目录，不是复制到项目代码目录。

### 需要 npm install 或 pip install 吗？

不需要。毕方开源版是文本 skills，不依赖 Node 或 Python。

### 为什么没有自动触发？

通常是目录放错，或者复制后没有重启会话。确认 `bifang-starter/SKILL.md` 在 skills 目录下，再新开一个会话测试。

### 能不能多账号使用？

可以。建议一个客户或一个账号开一个独立窗口，避免上下文混在一起。
