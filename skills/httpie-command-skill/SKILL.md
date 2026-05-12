---
name: httpie-command-skill
description: >-
  使用 xh（HTTPie 兼容 CLI）生成可复制执行的规范 HTTP/HTTPS 请求命令；约定 JSON 主体用带引号的 heredoc、复杂 JSON 不用键值拼体、默认不使用 curl，并避免为 stdin JSON 冗余手写 Content-Type。
  在用户需要接口调试命令、REST/gRPC 网关后的 HTTP 示例、xh 或 HTTPie 风格片段、明确要求不用 curl、或需要统一 heredoc/JSON 缩进与 Content-Type 规则时使用；亦适用于请求体中嵌入原始 SQL 条件串等「整段 JSON」场景。
---

# 使用场景

在用户要**生成或审阅**可在终端直接执行的 HTTP 调用，且希望默认走 **xh/HTTPie 兼容语法**（用户可能说 xh、HTTPie、http/https）时使用。典型触发包括：需要 **POST/PUT/PATCH** 的 **JSON body**；要禁止 **curl**（除非用户明确要求 curl）；要避免 **`-j` + 键值拼 JSON 主体**；要坚持 **`<<'EOF'`** heredoc；要说明或遵守 **不要手写 JSON 的 `Content-Type: application/json`**；或 body 内需保留 **未转义/可读的 SQL 条件字符串** 等整段 JSON 载荷。

# HTTP 工具规范

- 优先使用 **xh**（Rust 实现，HTTPie 兼容）。若环境中 `http`/`https` 指向 xh 或开启 `XH_HTTPIE_COMPAT_MODE`，与 `xh` 视为同一套规则。
- 禁止生成 curl（除非用户明确要求）。
- JSON POST/PUT/PATCH 请求：
  - 优先使用 heredoc 形式
  - 不使用 `-j`（与「键值构造 JSON」混用时的歧义；stdin 整段 JSON 不需要也不应依赖 `-j`）
  - 不使用 `field=value` 拼 JSON 主体（复杂体一律 heredoc 或 `@file`）
  - **禁止**为 JSON 请求体手写 `Content-Type: application/json`（或等价 `Content-Type:` 头）

# 为何不要手写 Content-Type

对 **stdin / heredoc / 管道** 传入的 JSON 请求体，xh 会**自动**设置 `Content-Type: application/json`（与 HTTPie 行为一致）。手写该头冗余且易与工具默认或后续改写不一致。

自证（本地可复现）：

```bash
echo '{}' | xh --offline -v POST https://httpbin.org/post
```

在打印的请求头中应能看到 `Content-Type: application/json`。

仅在以下情况才为 `Content-Type` / `Accept` 破例：接口文档明确要求非 JSON 的媒体类型、或必须覆盖 charset/边界（multipart）等 xh **无法**从请求形态推断的情形。

# JSON 请求格式

统一使用（命令名用 `xh`；若你习惯 `http` 且即为 xh，可替换为 `http`）：

```bash
xh POST <url> <<'EOF'
{
  ...
}
EOF
```

# heredoc 规范

- 必须使用：

  <<'EOF'

- 不使用：

  <<EOF

原因：

- 防止 shell 变量展开
- 防止 `$token`
- 防止反引号
- 防止转义污染

# JSON 格式规范

- JSON 必须格式化缩进
- 使用双引号
- 保持合法 JSON
- 不生成伪 JSON

# SQL / 条件表达式

涉及 SQL 时：

- 保持原始 SQL
- 不转义单引号
- 不压缩成单行
- 优先保持可读性

# 输出风格

- 命令可直接复制执行
- URL 单独一行
- JSON 保持 2/4 空格缩进
- EOF 顶格

# 正确示例

```bash
xh POST https://api.example.com/users <<'EOF'
{
  "name": "alice",
  "age": 18,
  "enabled": true
}
EOF
```

# 正确示例（复杂 SQL）

```bash
xh POST https://api.example.com/query <<'EOF'
{
  "selectCol": "union_id,sum(if(is_buying_traffic=1,1,0)) as media_cnt",
  "dbTable": "bcp_dw.ads_idmapping_user_attr_all_apps",
  "condition": "app='xparty' and union_id = 245 group by union_id"
}
EOF
```

# 错误示例（用 `-j` 与 键值拼 JSON 主体，而非 heredoc）

```bash
xh -j POST xxx \
  name=alice \
  age:=18
```

# 错误示例（不要手写 JSON 的 Content-Type）

```bash
xh POST https://api.example.com/users Content-Type:application/json <<'EOF'
{"name": "alice"}
EOF
```