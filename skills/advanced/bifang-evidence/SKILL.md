---
name: bifang-evidence
description: 毕方 V0.3 的作品证据包标准。用于导入视频分析器结果、逐字稿、关键帧、标题、发布时间、播放与转化数据，并让拆片、仿写、账号规划和复盘复用同一份资料。
---

# 毕方作品证据包 V0.3

证据包是一个 JSON 文件，不是额外问卷。它把“视频客观事实”和“业务判断”分开保存：前者来自视频/平台/客户记录，后者只允许在已有事实基础上填写，并标出不确定项。

## 文件与脚本

- `references/evidence-schema.md`：字段说明与最小示例。
- `scripts/import-viral-analyzer.mjs`：从 `viral-video-analyzer` 的 `result.json` 或任务目录导入。
- `scripts/validate-evidence.mjs`：检查缺失字段和时间顺序。
- `scripts/render-v0.3-workbench.mjs`：生成同一份资料的拆片、仿写、账号规划、复盘工作台提示词。
- `scripts/analyze-account-assets.mjs`：按播放、咨询/有效咨询/成交数据自动分出高播放、高转化、低效常发组，并给出当前主矛盾。
- `scripts/record-post-publish.mjs`：把 24–48 小时表现、评论意图和转化结果回写同一证据包。
- `scripts/build-week-plan.mjs`：依据资产分组和主矛盾生成可执行的 7 天发布表。

## 入口

```powershell
node bifang-evidence/scripts/import-viral-analyzer.mjs "viral-video-analyzer/backend/data/<task-id>" --out outputs/<task-id>.evidence.json --url "视频链接" --published-at "2026-07-22T10:00:00+08:00" --plays 12000 --likes 300 --comments 25 --shares 18 --inquiries 6 --conversions 1
node bifang-evidence/scripts/validate-evidence.mjs outputs/<task-id>.evidence.json
node bifang-evidence/scripts/render-v0.3-workbench.mjs outputs/<task-id>.evidence.json --industry "行业" --business "卖什么" --audience "目标客户" --pain "最大顾虑" --proof "真实证据" --out outputs/<task-id>-v0.3-workbench.md
node bifang-evidence/scripts/analyze-account-assets.mjs outputs/<account>.evidence.json --out outputs/<account>-assets.json
node bifang-evidence/scripts/build-week-plan.mjs outputs/<account>-assets.json --out outputs/<account>-week-plan.md
node bifang-evidence/scripts/record-post-publish.mjs outputs/<account>.evidence.json --video-id <video-id> --plays 12000 --completion-rate 0.31 --comments 90 --inquiries 8 --qualified-inquiries 3 --conversions 1 --comment-intent "用户主要询问预算与工期"
```

把生成的工作台交给毕方时，不要再重复粘贴视频链接、逐字稿、关键帧或数据。

## 关键规则

1. `facts` 只放视频、平台或客户可核验资料；空值不补猜。
2. `analysis` 是判断，必须引用片段 ID 或数据字段，且允许写“待验证”。
3. 老账号将多条 `videos` 放进同一证据包，至少包含高播放、高转化和低效常发三组。
4. 发布后只更新对应视频的 `performance` 和 `conversion`，下一次规划继续读取同一个文件。
5. 用作信任、结果或效果依据的客户原话、截图、案例和数据，额外记录来源、适用范围、时间和可公开性；无来源或授权时只保留为待核线索、匿名化问题或补问项。
