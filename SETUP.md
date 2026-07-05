# Phase 0 セットアップ手順

`gotchance.github.io` 向け Quarto サイトのローカル環境構築手順です。

## 前提（確認済み / 要対応）

| 項目 | 状態 |
|---|---|
| Git | インストール済み |
| TeX (pdfTeX) | インストール済み (TeX Live 2026) |
| Quarto | **要インストール**（下記） |
| GitHub CLI (`gh`) | 未インストール（ブラウザでリポジトリ作成可） |

## 1. Quarto のインストール

ターミナルで実行（管理者パスワードが必要）:

```bash
brew install --cask quarto
```

インストール後:

```bash
quarto --version
quarto check
```

`quarto check` で TeX も問題ないか確認してください。

## 2. ローカルプレビュー

プロジェクトディレクトリで:

```bash
cd "/Users/han/Downloads/cursor projects/CVprofile_confDL"
quarto preview
```

> **注意:** `CVprofile.md` と `conference_deadlines.md` は移行元ソースです。`_quarto.yml` の `render:` で `.qmd` のみを指定しています。これを外すと `---` 区切りを YAML と誤認識してエラーになります。

ブラウザで Home / CV / Conferences のナビゲーションが表示されれば Phase 0 完了です。

## 3. ビルド（GitHub Pages 用）

```bash
quarto render
```

出力先: `docs/`（`_quarto.yml` の `output-dir`）

初回ビルド後、`docs/.nojekyll` が無い場合は空ファイルを作成:

```bash
touch docs/.nojekyll
```

## 4. GitHub リポジトリ作成

1. https://github.com/new を開く
2. Repository name: **`gotchance.github.io`**
3. Public を選択
4. README / .gitignore は追加しない（ローカルに既にある）
5. Create repository

ローカルで初回 push:

```bash
cd "/Users/han/Downloads/cursor projects/CVprofile_confDL"
git init
git add .
git commit -m "Phase 0: Quarto site skeleton"
git branch -M main
git remote add origin https://github.com/gotchance/gotchance.github.io.git
git push -u origin main
```

## 5. GitHub Pages 有効化

リポジトリ **Settings → Pages**:

- **Source:** Deploy from a branch
- **Branch:** `main`
- **Folder:** `/docs`

数分後: https://gotchance.github.io/

## 6. 次のフェーズ

- **Phase 1:** `CVprofile.md` → `cv/index.qmd` へ移行、PDF 生成
- **Phase 2:** `conference_deadlines.md` → `conferences/` へ移行

## ディレクトリ構成（Phase 0 時点）

```
CVprofile_confDL/
├── _quarto.yml
├── index.qmd
├── cv/
│   ├── index.qmd          # Phase 1 で本文化
│   └── assets/
│       └── profile.jpg
├── conferences/
│   └── index.qmd          # Phase 2 で本文化
├── styles/
│   └── site.scss
├── CVprofile.md           # 移行元（保持）
├── conference_deadlines.md
├── README.md
└── SETUP.md               # 本ファイル
```
