# 作品证据包字段

```json
{
  "schema_version": "bifang-evidence/v0.3",
  "account": {"platform": "抖音", "account_name": "", "business": "", "audience": ""},
  "videos": [{
    "id": "video-001",
    "facts": {
      "source_url": "", "title": "", "published_at": "", "duration_seconds": null,
      "transcript_segments": [{"id":"s01","start":0,"end":3,"text":""}],
      "key_frames": [{"timestamp":0,"path":"","description":""}]
    },
    "performance": {"plays":null,"likes":null,"comments":null,"favorites":null,"shares":null,"completion_rate":null},
    "conversion": {"inquiries":null,"qualified_inquiries":null,"conversions":null,"revenue":null},
    "operator_notes": ""
  }]
}
```

`performance` 和 `conversion` 都允许为 `null`。`null` 表示未知，而不是 0。完整的视觉分析可写入 `key_frames.description`；没有视觉模型时，保留抽帧路径即可，不能凭路径描述画面。
