# kzeng.github.io

Hugo + PaperMod 内容站。你只管往 `content/posts/` 里丢 Markdown，push 之后 GitHub Actions 自动构建上线。

## 一、本地初始化（只需做一次）

前置：安装 **Hugo extended 版**（`hugo version` 输出要带 `+extended`）。

```bash
# 1. 进目录
cd kzeng-blog

# 2. 装主题（submodule 方式，方便以后升级）
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# 3. 初始化并推到 GitHub（推到 clash 分支，不碰线上 docs 目录）
git init
git add .
git commit -m "init"
git branch -M clash
git remote add origin https://github.com/kzeng/kzeng.github.io.git
git push -u origin clash
```

## 二、开启 GitHub Pages（只需做一次）

仓库 → **Settings → Pages → Source** → 选 **GitHub Actions**，保存。

之后每次 push，Actions 会自动构建并发布，约 30~60 秒后 `https://kzeng.github.io` 生效。

## 三、日常写内容（唯一需要重复做的事）

### 方式 A：用脚本，编号自动生成
```bash
./scripts/new.sh "今天写点什么"
# 输出：已创建：content/posts/p2026-09-11-001.md
```
同一天多次执行会自动递增为 `-002`、`-003`。如果脚本没执行权限，先 `chmod +x scripts/new.sh`。

### 方式 B：手动建文件
在 `content/posts/` 下按 `p2026-09-01-001.md` 命名，头部写：

```yaml
---
title: "文章标题"
date: 2026-09-01
draft: false
tags: ["随笔", "读书"]
categories: ["笔记"]
---

正文……
```

- `draft: true` 的文章不会发布，写一半就用它
- `tags` 随便填，标签页会自动聚合；不填也行
- 文件名 `p2026-09-01-001.md` 只用于排序，URL 由 `date` + `title` 决定

### 发布
```bash
git add .
git commit -m "add p2026-09-11-001"
git push
```

## 四、站点功能对照

| 功能 | 入口 |
|---|---|
| 列表页（带分页，每页 20 条） | `/` 或 `/posts/`，翻页 `/page/2/` |
| 详情页 | 点标题进入，右侧带目录、阅读时长、上下篇 |
| 标签 | 顶部「标签」，或 `/tags/` |
| 归档 | 顶部「归档」，按年月分组 |
| 搜索 | 顶部「搜索」，搜标题 / 正文 / 标签 |
| 主题切换 | 右上角图标，明暗自动/手动切换 |

## 五、常用本地预览

```bash
hugo server -D    # -D 含草稿，访问 http://localhost:1313
```

## 六、几个可调的地方（hugo.toml）

- `pagerSize`：每页条数，默认 20
- `defaultTheme`：`auto` / `light` / `dark`
- `params.fuseOpts.threshold`：搜索模糊度，0 最精确 1 最宽松，中文建议 0.3~0.4
- `params.ShowToc`：详情页右侧目录开关

## 七、升级主题

```bash
git submodule update --remote themes/PaperMod
git add themes/PaperMod && git commit -m "update theme" && git push
```
