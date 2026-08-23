#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
const args=process.argv.slice(2);const input=args.shift();function flag(n,f=""){const i=args.indexOf(n);if(i<0)return f;const v=args[i+1]??f;args.splice(i,2);return v;}
if(!input){console.error("Usage: node build-week-plan.mjs account-assets.json --out week-plan.md");process.exit(2);}const out=flag("--out","outputs/bifang-week-plan.md");const a=JSON.parse(fs.readFileSync(input,"utf8"));const high=a.groups?.highest_plays||[], convert=a.groups?.highest_conversion||[], low=a.groups?.lowest_effective||[];const pick=(list,index,fallback)=>list[index%Math.max(list.length,1)]||{title:fallback,id:"待补"};const days=[
 ["流量","把【"+pick(high,0,"高播放内容").title+"】里的钩子换成目标客户场景","复拍开头 3 秒的真实场景","评论区问：你现在最卡的是哪一步？","前 3 秒留存、精准评论"],
 ["信任","把【"+pick(convert,0,"高转化内容").title+"】中的判断过程拍出来","过程/材料/现场细节","评论区问：你是哪种情况？我发你对应清单。","收藏、有效评论"],
 ["成交","用【"+pick(convert,1,"高转化内容").title+"】回答一次常见顾虑","客户授权的案例或流程证据","私信第一问：你的情况/预算/时间分别是什么？","有效私信、合格咨询"],
 ["流量→信任","用高播放入口解释一个真实误区","钩子后立刻给证据画面","评论区问：要不要看完整版判断表？","完播、收藏"],
 ["人设/复盘","复盘本周用户反复问的一个问题","评论截图或真实工作场景","评论区问：下条先拆哪一种？","评论意图、关注"],
 ["成交","把【"+pick(convert,2,"成交内容").title+"】做成适合/不适合筛选题","边界、流程、准备材料","私信第一问：先发你目前的情况。","合格咨询、成交"],
 ["停发替换","停止【"+pick(low,0,"低效内容").title+"】式表达，改拍目标用户的真实决策题","替代场景与证据","评论区问：你最担心哪个风险？","播放是否回升、评论是否更精准"]
];
const lines=["# 毕方 7 天发布表","",`- 当前主矛盾：${a.primary_problem||"待判断"}`,`- 数据依据：${(a.evidence||[]).join("；")||"待补"}`,"","| 天数 | 内容角色 | 第一条句子/选题 | 证据画面 | 承接 | 发布后看什么 |","|---|---|---|---|---|---|"];days.forEach((d,i)=>lines.push(`| Day ${i+1} | ${d[0]} | ${d[1]} | ${d[2]} | ${d[3]} | ${d[4]} |`));lines.push("","## 24–48 小时后的动作","- 播放和前 3 秒差：保留证据，改第一句与第一镜头。","- 播放高但有效私信低：下条把目标人群、适用边界与筛选问题前置。","- 收藏/有效私信高：扩成系列，保留场景与承接。","- 低效内容仍无精准反馈：停止同题重复，回到高转化内容的证据结构。");fs.mkdirSync(path.dirname(path.resolve(out)),{recursive:true});fs.writeFileSync(out,lines.join("\n"),"utf8");console.log(JSON.stringify({ok:true,out,days:days.length},null,2));
