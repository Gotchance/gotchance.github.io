# Phase 0 セットアップ手順

`gotchance.github.io` 向け Quarto サイトのローカル環境構築手順です。

## 前提（確認済み / 要対応）

| 項目 | 状態 |
|---|---|
| Git | インストール済み |
| TeX (pdfTeX) | インストール済み (TeX Live 2026) |
| Quarto | インストール済み (1.9.38) |
| GitHub リポジトリ | **未作成**（`gotchance.github.io` → push で 404） |

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

> **注意:** `rawdata_hackmd/*.md` は HackMD 移行元です。`_quarto.yml` の `render:` で `.qmd` のみを指定しています。ルートや `rawdata_hackmd/` の `.md` を render 対象に入れると `---` 区切りを YAML と誤認識してエラーになります。

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

## 4. GitHub リポジトリ作成と push

### エラー: `remote: Repository not found`

**原因:** GitHub 上に `gotchance/gotchance.github.io` がまだ存在しない（404 確認済み）。  
`git remote add` だけではリポジトリは作られません。**先に GitHub 上で空リポジトリを作成**してください。

### 手順

1. **ログイン確認** — ブラウザで https://github.com/gotchance にアクセスし、ご自身のアカウントか確認
2. **リポジトリ作成** — https://github.com/new
   - Owner: **gotchance**
   - Repository name: **`gotchance.github.io`**（完全一致）
   - Visibility: **Public**
   - **Add a README / .gitignore / license はすべてオフ**
   - Create repository
3. **ビルド成果物を含めて push**（GitHub Pages は `/docs` フォルダを参照するため）

```bash
cd "/Users/han/Downloads/cursor projects/CVprofile_confDL"
quarto render
touch docs/.nojekyll
git add docs/
git commit -m "Add rendered site to docs/"   # 初回のみ。既に commit 済みならこの行は不要
git push -u origin main
```

`git remote add` は既に設定済みの場合は不要です。  
再度 `Repository not found` が出る場合:

- リポジトリ名の typo（`gotchance.github.io` か）
- 別アカウントでログインしている（HTTPS の認証ユーザーが `gotchance` か）
- リポジトリが Private で権限がない

認証確認（GitHub CLI がある場合）:

```bash
gh auth status
```

### 初回セットアップ（リモート未設定の場合）

```bash
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

- **Phase 1:** `rawdata_hackmd/CVprofile.md` → `cv/index.qmd` へ移行、PDF 生成
- **Phase 2:** `rawdata_hackmd/conference_deadlines.md` → `conferences/` へ移行

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
├── rawdata_hackmd/
│   ├── CVprofile.md           # HackMD 移行元
│   └── conference_deadlines.md
├── docs/                      # quarto render 出力（GitHub Pages 公開用）
├── README.md
└── SETUP.md
```
