# dotfiles-cursor

Cursor IDE 的规则（Rules）与技能（Skills）配置，用于在编辑器中统一 AI 行为与编码规范。

## 内容概览

### Rules（规则）

| 文件 | 说明 | 作用范围 |
|------|------|----------|
| `rules/RIPER-5-CN.mdc` | RIPER-5 协议：研究 / 创新 / 规划 / 执行 / 审查工作流，默认中文响应 | 全局（alwaysApply） |
| `rules/go.mdc` | Go 编码规范：引用 Go skills，强调地道写法、避免 goroutine 泄漏与全局可变状态 | `**/*.go` |

### Skills（技能）

位于 `skills/` 下，每个子目录为一个技能（内含 `SKILL.md`）：

| 技能 | 说明 |
|------|------|
| **go-concurrency** | Goroutine 生命周期、channel、mutex、sync 等并发模式（参考 Google / Uber Go Style Guide） |
| **go-error-handling** | 错误返回、`%w` 包装、哨兵错误、错误类型选择、日志与处理流程（Google / Uber 风格） |
| **go-performance** | 性能相关：字符串处理、类型转换、容器容量预分配等（Uber Go Style Guide） |
| **httpie-command-skill** | 用 **xh**（HTTPie 兼容 CLI）生成可执行的 HTTP/HTTPS 命令；约定 JSON 用 heredoc、默认不用 curl |
| **use-modern-go** | 按项目 Go 版本使用现代语法与最佳实践 |

## 安装

将本仓库克隆到本地后，运行仓库根目录下的 `install.sh`：会把 `rules/` 中的**每个规则文件**软链到 `~/.cursor/rules/`，把 `skills/` 中的**每个技能目录**软链到 `~/.cursor/skills/`（使用绝对路径，便于 Cursor 解析）。

```bash
git clone https://github.com/bwangelme/dotfiles-cursor.git ~/dotfiles-cursor
~/dotfiles-cursor/install.sh
```

之后在 Cursor 中打开任意项目即可使用上述 rules 与 skills；更新配置时只需 `git pull` 再执行一次 `install.sh`（会覆盖同名软链）。

## 目录结构

```
dotfiles-cursor/
├── README.md
├── install.sh
├── rules/                 # Cursor Rules（.mdc）
│   ├── RIPER-5-CN.mdc
│   └── go.mdc
└── skills/                # Cursor Skills（各子目录内 SKILL.md）
    ├── go-concurrency/
    ├── go-error-handling/
    ├── go-performance/
    ├── httpie-command-skill/
    └── use-modern-go/
```
