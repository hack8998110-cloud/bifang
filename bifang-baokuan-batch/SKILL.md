---
name: bifang-baokuan-batch
description: Use this skill when the user asks to batch-generate, audit, or merge a large number of short-video scripts. Handles file naming, line-count validation, numbering extraction, deduplication, and merge of multi-batch markdown outputs. Pairs with `bifang-script` and `bifang-review` for content quality.
---

# 批量脚本生成与运维 V0.1 内测版

> 角色：批量运维 ｜ 职责：管批次，不管单条创作细节

## 适用场景

- 一次生成 ≥ 10 条脚本
- 多批次产出后要合并 / 去重 / 漏号检查
- 补跑脚本（替换已有编号或填补缺失编号）
- 文件碎片清理（散文件 → 批处理文件 → 删旧）

不适合：单条脚本撰写（用 `bifang-script`）

## 职责边界

- ✅ 负责文件管理、漏号、合并、去重、批次整理
- ✅ 负责批量产物的结构化检查
- ❌ 不负责单条脚本内容质量判断
- ❌ 不负责单条脚本的完整创作
- ❌ 不替代审核技能做质检结论

## 文件命名规范

| 类型 | 命名 | 示例 |
|------|------|------|
| 单批次 | `<起>-<止>.md` | `001-005.md`、`101-105.md` |
| 大批次合并 | `<起>-<止>.md` | `001-060.md`、`101-120.md` |
| 补跑文件 | `<起>-<止>-fix.md` | `047-fix.md`、`077-087-fix.md` |
| 选题清单 | `topics-<日期>.md` | `topics-2026-05-13.md` |

**铁律**：
- 散文件（如 `47.md`）视为临时碎片，处理完后应合并入大文件
- 同一编号范围出现多版本时，保留更大覆盖范围的那个

## 批量运维流程

### 1. 行数验证

删除任何文件前先检查行数。

```bash
wc -l <file>
# 或 Windows bash:
awk 'END{print NR}' <file>
```

### 2. 编号提取与漏号检查

```bash
# 提取所有编号
grep -hE "^#+ 脚本[：:\s]*[0-9]+" *.md \
  | sed -E 's/.*脚本[：:\s]*([0-9]+).*/\1/' \
  | sort -n | uniq

# 找漏号（假设目标 1-60）
seq 1 60 | sort > /tmp/expected.txt
grep -hE "^#+ 脚本[：:\s]*[0-9]+" *.md \
  | sed -E 's/.*脚本[：:\s]*([0-9]+).*/\1/' \
  | sort -n | uniq > /tmp/actual.txt
comm -23 /tmp/expected.txt /tmp/actual.txt   # 缺失编号
comm -13 /tmp/expected.txt /tmp/actual.txt   # 多余编号
```

### 3. 重复编号处理

- 补跑文件优先
- 用补跑内容替换总文件对应位置
- 删除补跑临时文件

## 选题去重 SOP

1. 列已有选题清单（标题 + 核心论点）
2. 新选题先比对核心论点，不只看标题字面
3. 同论点只保留一条，重复直接合并
4. 同批次内尽量避免相近角度连续出现

## 常见问题速查

| 问题 | 处理方式 |
|------|---------|
| 单编号散文件 | 合并到批处理文件后删除 |
| 行数过少的碎片文件 | 先确认是否缺内容，再决定删除 |
| 重复合并文件 | 保留大的，删小的 |
| 补跑完成后有重复编号 | 以补跑文件为准 |
| 代理报告完成但文件不完整 | 必走行数验证 + 编号提取双重检查 |
| 漏号 / 跳号 | 用补跑文件填补 |

## 与其他技能的协作

- `bifang-topic`：负责批量选题
- `bifang-script`：负责每条脚本内容
- `bifang-review`：负责最终审核

## 关键铁律

1. 删除文件前先验行数
2. 散文件不是最终态
3. 补跑覆盖原内容，不并存
4. 选题去重看核心论点，不看字面
5. 总文件命名按最大覆盖编号段
