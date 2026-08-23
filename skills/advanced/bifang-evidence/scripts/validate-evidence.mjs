#!/usr/bin/env node
import fs from "node:fs";
const input = process.argv[2]; if (!input) { console.error("Usage: node validate-evidence.mjs evidence.json"); process.exit(2); }
const data = JSON.parse(fs.readFileSync(input, "utf8")); const errors = [], warnings = [];
if (data.schema_version !== "bifang-evidence/v0.3") errors.push("schema_version must be bifang-evidence/v0.3");
if (!Array.isArray(data.videos) || !data.videos.length) errors.push("videos must contain at least one video");
for (const [index, video] of (data.videos || []).entries()) { const facts = video.facts || {}; if (!video.id) errors.push(`videos[${index}].id is required`); if (!facts.title && !facts.source_url) warnings.push(`videos[${index}] lacks both title and source_url`); let last = -1; for (const segment of facts.transcript_segments || []) { if (!Number.isFinite(segment.start) || !Number.isFinite(segment.end) || segment.end < segment.start) errors.push(`${video.id}: invalid transcript timestamp`); if (segment.start < last) errors.push(`${video.id}: transcript is not ordered`); last = segment.start; } if (!(facts.transcript_segments || []).length) warnings.push(`${video.id}: no transcript; structural claims must be marked inferred`); }
console.log(JSON.stringify({ ok: !errors.length, errors, warnings, videos: data.videos?.length || 0 }, null, 2)); if (errors.length) process.exitCode = 1;
