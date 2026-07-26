# 毕方安装说明

毕方是 Codex/Agent skills 目录包，本质是一组文本规则文件。

它不限制系统，不需要编译，也不需要安装依赖。Windows、macOS、Linux 都可以使用。

安装动作只有一个：

```text
把需要的 bifang-* 文件夹复制到你的 Agent/Codex skills 目录。
```

## skills 目录在哪里

Codex 默认 skills 目录通常是：

Windows：

```text
C:\Users\你的用户名\.codex\skills
```

macOS / Linux：

```text
~/.codex/skills
```

如果你的 Agent 平台使用了自定义 skills 目录，就复制到对应目录即可。

## 一键安装

Windows PowerShell：

```powershell
.\install.ps1
```

macOS / Linux：

```bash
chmod +x ./install.sh
./install.sh
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

Windows：

```powershell
.\install.ps1 -All
```

macOS / Linux：

```bash
./install.sh --all
```

如果你的 skills 目录不是默认位置：

Windows：

```powershell
.\install.ps1 -Destination "D:\your\skills"
```

macOS / Linux：

```bash
./install.sh --destination "/your/skills"
```

## 手动安装

手动安装适合所有系统。

1. 找到你的 Codex skills 目录。

Windows：

```text
C:\Users\你的用户名\.codex\skills
```

macOS / Linux：

```text
~/.codex/skills
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

Windows：

```text
C:\Users\你的用户名\.codex\skills\bifang-starter\SKILL.md
C:\Users\你的用户名\.codex\skills\bifang-topic\SKILL.md
C:\Users\你的用户名\.codex\skills\bifang-script\SKILL.md
```

macOS / Linux：

```text
~/.codex/skills/bifang-starter/SKILL.md
~/.codex/skills/bifang-topic/SKILL.md
~/.codex/skills/bifang-script/SKILL.md
```

每个 skill 文件夹里必须有 `SKILL.md`。

## 常见问题

### 复制到哪里？

复制到你的 Agent/Codex skills 目录，不是复制到项目代码目录。

### 需要 npm install 或 pip install 吗？

不需要。毕方开源版是文本 skills，不依赖 Node 或 Python。

### 支持 Mac 吗？

支持。毕方没有 Windows 或 Mac 限制，只要你的 Agent 支持加载本地 skills 目录即可。

### 为什么没有自动触发？

通常是目录放错，或者复制后没有重启会话。确认 `bifang-starter/SKILL.md` 在 skills 目录下，再新开一个会话测试。

### 能不能多账号使用？

可以。建议一个客户或一个账号开一个独立窗口，避免上下文混在一起。
