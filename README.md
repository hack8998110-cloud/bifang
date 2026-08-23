# 毕方 V0.3.6

毕方是一套商业短视频内容判断 Skills：先判断用户真正想看什么，再生成选题、脚本、审核意见和发布复盘。

它不是账号管理 SaaS，也不承诺爆款。它帮助你把“我想卖什么”翻译成“用户为什么会看、相信和行动”。

## 3 分钟开始

首次使用只装 6 个核心模块：

```powershell
.\install.ps1
.\validate-install.ps1
```

然后在新的 Agent/Codex 会话中输入：

```text
用 bifang-starter 帮我判断该拍什么。
我做【行业】，主要卖【产品/服务】；目标用户是【谁】；我想获得【到店/私信/成交】；我现有证据是【案例/现场/过程/反馈】。
```

有对标视频、老账号或历史作品数据时，安装全部公开模块：

```powershell
.\install.ps1 -All
.\validate-install.ps1 -All
```

详细安装见 [安装指南](docs/guides/installation.md)，首次提问见 [快速开始](docs/guides/quickstart.md)。

## 你会得到什么

1. 用户真正想看的判断题；
2. 今天优先拍的内容；
3. 每条内容需要的真实证据和承接动作；
4. 已发布内容的保留、停止、重写与下一周计划。

## 模块分层

| 分层 | 适合谁 | 模块 |
|---|---|---|
| 核心 | 第一次使用、日常创作 | `starter`、`topic`、`script`、`review`、`rewrite`、`feedback` |
| 进阶 | 客户交付、对标拆片、老账号 | `intake`、`diagnosis`、`profile`、`assets`、`report`、`clip`、`account-plan`、`evidence` |
| 兼容 | 旧工作流使用者 | `baokuan`、`baokuan-batch` |

模块目录见 [`skills/`](skills/)。新用户从 `bifang-starter` 开始，不需要理解全部模块。

## 两条推荐路径

```text
新行业 / 新账号：starter → topic → script → review → feedback
已有视频 / 老账号：evidence → clip 或 account-plan → review → feedback
```

产品能力说明见 [V0.3 产品说明](docs/product/v0.3-product.md)，当前版本变更见 [V0.3.6 发布说明](docs/releases/v0.3.6.md)。

## 开源边界

公开仓库仅包含通用规则、匿名样例和可复现测试；不包含私有研究、达人资料、客户数据、报价或内测交付记录。历史材料统一放在 [`docs/archive/`](docs/archive/)，不进入发布包。

## 验证与反馈

- 安装后运行 [自测用例](tests/self_check_cases.md)。
- 公开能力验收见 [验收清单](tests/open_source_acceptance.md)。
- 发布维护者使用 [发布清单](docs/release_checklist.md)。

## 许可

见 [LICENSE](LICENSE)。
