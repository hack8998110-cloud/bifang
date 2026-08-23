#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

const args = process.argv.slice(2);
const source = args.shift();
function flag(name, fallback = "") { const i = args.indexOf(name); if (i < 0) return fallback; const v = args[i + 1] ?? fallback; args.splice(i, 2); return v; }
function number(name) { const value = flag(name, ""); return value === "" ? null : Number(value); }
if (!source) { console.error("Usage: node import-viral-analyzer.mjs <result.json|task-directory> --out evidence.json [--url URL --plays N ...]"); process.exit(2); }
const out = flag("--out");
if (!out) { console.error("--out is required"); process.exit(2); }
const absolute = path.resolve(source);
const taskDir = fs.statSync(absolute).isDirectory() ? absolute : path.dirname(absolute);
const resultPath = fs.statSync(absolute).isDirectory() ? path.join(absolute, "result.json") : absolute;
const result = fs.existsSync(resultPath) ? JSON.parse(fs.readFileSync(resultPath, "utf8")) : {};
const transcriptPath = path.join(taskDir, "transcript.json");
const transcript = result.transcript || (fs.existsSync(transcriptPath) ? JSON.parse(fs.readFileSync(transcriptPath, "utf8")) : []);
const framesDir = path.join(taskDir, "frames");
const frames = (result.segments || []).flatMap((segment) => segment.frames || []).map((frame) => ({ timestamp: frame.timestamp, path: frame.frame_path || frame.path || "", description: frame.visual_description || "", shot_type: frame.shot_type || "", camera_movement: frame.camera_movement || "", composition: frame.composition || "", mood: frame.mood || "" }));
if (!frames.length && fs.existsSync(framesDir)) for (const name of fs.readdirSync(framesDir)) { const match = name.match(/_(\d+(?:\.\d+)?)s\.(?:jpg|jpeg|png)$/i); if (match) frames.push({ timestamp: Number(match[1]), path: path.relative(process.cwd(), path.join(framesDir, name)).replaceAll("\\", "/"), description: "" }); }
const meta = result.video_meta || {};
const video = {
  id: result.task_id || path.basename(taskDir),
  facts: {
    source_url: flag("--url", ""), title: flag("--title", meta.title || ""), published_at: flag("--published-at", ""),
    duration_seconds: meta.duration ?? (transcript.at(-1)?.end ?? null), author: meta.author || "", transcript_segments: transcript.map((s, i) => ({ id: `s${String(i + 1).padStart(2, "0")}`, start: s.start, end: s.end, text: s.text || "" })), key_frames: frames.sort((a,b) => a.timestamp - b.timestamp), viral_analysis: result.viral_analysis || null
  },
  performance: { plays: number("--plays"), likes: number("--likes"), comments: number("--comments"), favorites: number("--favorites"), shares: number("--shares"), completion_rate: number("--completion-rate") },
  conversion: { inquiries: number("--inquiries"), qualified_inquiries: number("--qualified-inquiries"), conversions: number("--conversions"), revenue: number("--revenue") },
  operator_notes: flag("--notes", "")
};
const evidence = { schema_version: "bifang-evidence/v0.3", created_at: new Date().toISOString(), account: { platform: flag("--platform", "抖音"), account_name: flag("--account", ""), business: flag("--business", ""), audience: flag("--audience", "") }, videos: [video] };
fs.mkdirSync(path.dirname(path.resolve(out)), { recursive: true }); fs.writeFileSync(out, JSON.stringify(evidence, null, 2), "utf8");
console.log(JSON.stringify({ ok: true, out, videoId: video.id, transcriptSegments: transcript.length, keyFrames: frames.length }, null, 2));
