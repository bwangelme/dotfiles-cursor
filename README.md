# dotfiles-cursor

Cursor IDE 的规则（Rules）与技能（Skills）配置，用于在编辑器中统一 AI 行为与编码规范。

## 内容概览

### Rules（规则）

| 文件 | 说明 | 作用范围 |
|------|------|----------|
| `cursor/rules/RIPER-5-CN.mdc` | RIPER-5 协议：研究 / 创新 / 规划 / 执行 / 审查工作流，默认中文响应 | 全局（alwaysApply） |
| `cursor/rules/go.mdc` | Go 编码规范：引用 Go skills，强调地道写法、避免 goroutine 泄漏与全局可变状态 | `**/*.go` |

### Skills（技能）

位于 `cursor/skills/go-skills/`：

| 技能 | 说明 |
|------|------|
| **go-concurrency** | Goroutine 生命周期、channel、mutex、sync 等并发模式（参考 Google / Uber Go Style Guide） |
| **go-performance** | 性能相关：字符串处理、类型转换、容器容量预分配等（Uber Go Style Guide） |
| **modern-go** | 按项目 Go 版本使用现代语法与最佳实践 |

## 安装

将本仓库克隆到本地后，用符号链接挂到 Cursor 配置目录：

```bash
git clone https://github.com/bwangelme/dotfiles-cursor.git ~/dotfiles-cursor

mkdir -p ~/.cursor
rm -rf ~/.cursor/skills ~/.cursor/rules 2>/dev/null

ln -s ~/dotfiles-cursor/cursor/skills ~/.cursor/skills
ln -s ~/dotfiles-cursor/cursor/rules  ~/.cursor/rules
```

之后在 Cursor 中打开任意项目即可使用上述 rules 与 skills；拉取最新提交即可更新配置。

## 目录结构

```
dotfiles-cursor/
├── README.md
└── cursor/
    ├── rules/           # Cursor Rules（.mdc）
    │   ├── RIPER-5-CN.mdc
    │   └── go.mdc
    └── skills/          # Cursor Skills（SKILL.md）
        └── go-skills/
            ├── go-concurrency/
            ├── go-performance/
            └── modern-go/
```
