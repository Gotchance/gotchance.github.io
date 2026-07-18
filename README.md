# CV & Conference Deadlines — 移行プラン

HackMD で公開中の CV と学会締切情報を、研究者向けの静的 Web サイト + PDF 出力可能な構成へ移行するための計画書です。

| 現状 (HackMD) | 移行後 (目標) |
|---|---|
| [CV](https://hackmd.io/@gotchance/BJ7ACLZ0E) | 研究者向け CV ページ + PDF ダウンロード |
| [Conference Deadlines](https://hackmd.io/@gotchance/rJEW9rEoV) | 独立した「学会情報」ページ |

---

## 1. 現状分析

### 1.1 ソースファイル

| ファイル | 内容 | 行数規模 |
|---|---|---|
| `rawdata_hackmd/CVprofile.md` | 経歴・論文・受賞・プロジェクト等（HackMD 移行元） | 約 450 行 |
| `rawdata_hackmd/conference_deadlines.md` | 学会一覧・Tier 分類・ワークショップ等（HackMD 移行元） | 約 310 行 |

### 1.2 HackMD 固有の記法（移行時に変換が必要）

**rawdata_hackmd/CVprofile.md**

- HTML テーブル + `<font size>` によるヘッダー（プロフィール写真・連絡先）
- `<details>` / `<summary>` による折りたたみ（2023 年以前の論文、日本語履歴等）
- `<br>`, `---` による区切り
- Imgur ホスティングの画像（プロフィール写真、メールアドレス画像）
- HTML コメント `<!-- ... -->` 内の下書き・非公開情報

**rawdata_hackmd/conference_deadlines.md**

- HackMD メタデータ `[name=Chansu Han]`
- `:::info` ブロック（Tier 説明）
- 非常に幅の広い Markdown テーブル（横スクロール前提）

### 1.3 移行後に満たしたい要件

1. **研究者 CV として一般的な見た目**（写真 + 名前 + 所属 + リンク、セクション分け、読みやすい typography）
2. **PDF 出力**（Web ページと内容を同期、ワンコマンド or CI で生成）
3. **学会締切は別ページ**（ナビゲーションから CV と行き来可能）
4. **Markdown をソース・オブ・トゥルース**として維持（更新しやすさ）
5. **既存 URL からの移行**（可能ならリダイレクト or 旧 URL に移行先を明記）

---

## 2. ホスティング先の比較

| 観点 | GitHub Pages | GitLab Pages | Google Sites |
|---|---|---|---|
| Markdown 駆動 | ◎（Jekyll / Hugo / Quarto 等） | ◎（ほぼ同等） | △（手入力 or コピペ中心） |
| PDF 自動生成 (CI) | ◎ GitHub Actions | ◎ GitLab CI | × 困難 |
| カスタムドメイン | ◎ 無料 | ◎ 無料 | ◎ 無料 |
| 研究者での普及度 | ◎ 非常に多い | ○ やや少ない | ○ 非エンジニア向け |
| バージョン管理 | ◎ Git | ◎ Git | × |
| 学会テーブルの表現 | ◎ HTML/CSS で最適化可能 | ◎ 同上 | △ 表編集が面倒 |
| 学習コスト | 中 | 中 | 低 |

### 推奨: **GitHub Pages + Quarto（第 1 候補）**

理由:

- **1 つの Markdown から HTML と PDF を両方生成**できる（CV の二重管理を避けられる）
- 研究者コミュニティで Quarto の利用が増えている
- GitHub Actions で push 時にサイト公開 + PDF 生成が可能
- 学会ページは HTML テーブル or 別 Markdown として柔軟に扱える

### 第 2 候補: **GitHub Pages + Jekyll（academicpages 系）**

- 学術系 CV サイトの de facto スタンダードに近い
- テーマが豊富（[academicpages](https://github.com/academicpages/academicpages.github.io), [al-folio](https://github.com/alshedivat/al-folio) 等）
- PDF は LaTeX テンプレート（moderncv 等）を別途用意するパターンが多い → CV の二重管理リスク

### 非推奨（本プロジェクトの要件に対して）: **Google Sites**

- Markdown ソースとの同期が難しい
- PDF 自動生成パイプラインを組みにくい
- 大規模テーブル（学会一覧）の更新効率が低い

> **結論:** GitHub を主軸に進め、GitLab を使いたい場合は CI 設定のみ差し替え可能な構成にする。

---

## 3. 目標アーキテクチャ

```
CVprofile_confDL/
├── README.md                    # 本ファイル
├── _quarto.yml                  # Quarto サイト設定
├── index.qmd                    # トップ → CV へリダイレクト or 簡易プロフィール
├── cv/
│   ├── cv.qmd                   # CV 本文（CVprofile.md から移行）
│   ├── cv-pdf.qmd               # PDF 用（Web 版と共通 include）
│   ├── _sections/               # セクション分割（任意）
│   │   ├── publications.qmd
│   │   ├── awards.qmd
│   │   └── services.qmd
│   └── assets/
│       └── profile.jpg          # プロフィール写真（Imgur から移行）
├── conferences/
│   ├── index.qmd                # 学会締切トップ
│   ├── list.qmd                 # メインの学会テーブル
│   ├── tier.qmd                 # Tier 分類・Open Access 情報
│   └── workshops.qmd            # ワークショップ・国内学会
├── styles/
│   ├── site.scss                # Web 用スタイル
│   └── cv-print.scss            # PDF / 印刷用
├── .github/
│   └── workflows/
│       └── deploy.yml           # Pages 公開 + PDF artifact
└── docs/                        # ビルド出力（GitHub Pages 公開先）
    ├── index.html
    ├── cv/
    │   ├── index.html
    │   └── Chansu_Han_CV.pdf    # 生成 PDF
    └── conferences/
        └── index.html
```

### 公開 URL イメージ

| ページ | URL 例 |
|---|---|
| CV (Web) | `https://gotchance.github.io/cv/` |
| CV (PDF) | `https://gotchance.github.io/cv/Chansu_Han_CV.pdf` |
| 学会情報 | `https://gotchance.github.io/cv/conferences/` |

※ リポジトリ名・ユーザー名は実際の GitHub アカウントに合わせて調整。

---

## 4. デザイン方針

### 4.1 CV ページ（Web）

研究者 CV でよく見るレイアウト:

```
┌─────────────────────────────────────────────────┐
│  [写真]   Chansu Han, Ph.D.                     │
│           Researcher, NICT                      │
│           📧 email  |  Scholar | dblp | ORCID … │
├─────────────────────────────────────────────────┤
│  Biography                                      │
│  Research Topics                                │
│  Featured Publications                          │
│  Publications  (折りたたみ or 年別)              │
│  Awards                                         │
│  Projects                                       │
│  Professional Services                          │
│  Academic Background                            │
│  [Download CV (PDF)]                            │
└─────────────────────────────────────────────────┘
```

**スタイル指針**

- 最大幅 900px 前後、セリフ or サンセリフ（例: Source Sans 3 + Noto Sans JP）
- 見出しは `h2` でセクション区切り、論文リストは番号付き
- 折りたたみ: Quarto の `::: {.panel-collapse}` または `<details>` を CSS で整形
- モバイル: ヘッダーを縦積み、テーブルは横スクロール
- ナビ: 固定ヘッダーに `CV | Conferences | PDF`

### 4.2 CV（PDF）

- A4、余白 2 cm 前後
- Web 版より **コンパクト**（折りたたみ内の古い論文も展開して掲載するかは要判断）
- ヘッダー: 名前・所属・連絡先・ORCID
- フッター: ページ番号 + 「Last updated: YYYY-MM-DD」
- 生成: `quarto render cv/cv-pdf.qmd --to pdf`

### 4.3 学会締切ページ

- ページ上部: ランキング・CFP カレンダーへのリンク集（現状の bullet リストを維持）
- メインテーブル: **横スクロール可能な wrapper** + スティッキー 1 列目（学会名）
- Tier 色分け: T1=濃色, T2=中, T3=薄色（背景色 or バッジ）
- `:::info` ブロック → Quarto の callout（`::: {.callout-note}`）へ変換
- 国内学会・ワークショップは別セクション or 別サブページ

---

## 5. コンテンツ移行マッピング

### 5.1 CVprofile.md → cv.qmd

| 現セクション | 移行後 | 備考 |
|---|---|---|
| ヘッダー（テーブル + 画像） | YAML metadata + HTML/CSS grid | メール画像 → テキスト or obfuscated mailto |
| Current Position | `## Current Position` | `<font>` 削除 |
| Biography / Research Topics | そのまま | |
| Featured Publications | そのまま | Tier 表記 `(Tier 1)` は維持 |
| Publications (各サブセクション) | 番号リスト | `<details>` → PDF 版は全展開、Web 版は折りたたみ |
| Awards/Honors | 統合（重複あり） | 上部と Others 内の重複を整理 |
| Others (Projects, Patents, …) | セクション分割 | |
| Professional Services | そのまま | |
| Academic Background | テーブル → Quarto pipe table | |
| 履歴 (日本語) | `<details>` 内を維持 | 必要なら `/cv/ja` サブページも検討 |

**画像の移行**

- `https://i.imgur.com/ahiyDkr.jpg` → `assets/profile.jpg` にダウンロードしてリポジトリ内管理
- メールアドレス画像 → **テキスト + CSS** または Cloudflare Email Protection 等（スパム対策）

**HTML コメント内の下書き**

- 非公開論文・Rejected 等は引き続きコメントアウト or `_drafts/` に分離

### 5.2 conference_deadlines.md → conferences/

| 現セクション | 移行先ファイル |
|---|---|
| Ranking / CFP Calendar リンク | `conferences/index.qmd` 冒頭 |
| Conference List テーブル | `conferences/data/conferences.yml` → 生成 `conferences/_list.qmd` |
| Workshop / Domestic テーブル | `conferences/workshops.qmd` |
| By Tier (+ :::info) | `conferences/tier.qmd` |
| Journal リンク | `conferences/index.qmd` 末尾 |

**テーブル最適化案**

- 年列（2027〜2020）が多い → **直近 3 年 + 「Older」列**に縮小するか、年を行・学会を列に転置を検討
- **YAML 化済み**: `conferences/data/conferences.yml` を編集 → `quarto render`（pre-render で `_list.qmd` を再生成）

**YAML の書き方（例）**

```yaml
- name: NDSS
  tier: "1"
  approx_dl: May, Aug
  h5: https://scholar.google.com/...
  editions:
    2027:
      label: Mar 22-26, Seoul, Korea
      url: https://www.ndss-symposium.org/ndss2027/
      dl: May 6, Aug 19
```

初回のみ: `python3 -m venv .venv && .venv/bin/pip install -r requirements.txt`

---

## 6. 実装フェーズ

### Phase 0: 準備（1 日）

- [x] プロジェクト骨格作成（`_quarto.yml`, `index.qmd`, `cv/`, `conferences/`, `styles/`）
- [x] プロフィール写真を `cv/assets/profile.jpg` に保存
- [x] TeX 環境確認（TeX Live 2026 済み）
- [x] `SETUP.md` にローカル構築手順を記載
- [x] **Quarto ローカルインストール**（1.9.38）
- [x] `quarto render` でローカルビルド確認（`render:` でソース `.md` を除外）
- [x] **GitHub リポジトリ作成**（`Gotchance/gotchance.github.io`）
- [x] `quarto preview` でローカル確認
- [x] `docs/` を push 済み
- [x] GitHub Pages 有効化（https://gotchance.github.io/ 公開確認済み）

### Phase 1: CV ページ MVP（2〜3 日）

- [x] `_quarto.yml` でサイト骨格・ナビ・テーマ設定
- [x] `rawdata_hackmd/CVprofile.md` → `cv/_content.qmd`（HackMD 記法除去）
- [x] `cv/index.qmd` ヘッダー（写真 + メール + リンク）+ 本文 include
- [x] PDF 初版: `cv/cv-pdf.qmd`（xelatex + 日本語フォント）→ `docs/cv/Chansu_Han_CV.pdf`
- [x] 「Download CV (PDF)」ボタン / ナビリンク
- [x] `post-render` で PDF 自動生成（`scripts/render-cv-pdf.sh`）
- [x] ローカル `quarto preview` で見た目確認 → `docs/` を push

### Phase 2: 学会ページ（2 日）

- [x] `conference_deadlines.md` を `conferences/` 配下に分割移行（案 A: 2027–2020 全列＋横スクロール）
- [x] 横スクロールテーブルの CSS 実装（`.table-scroll` / sticky Conf 列）
- [x] `:::info` → 箇条書き／callout 変換
- [x] CV ページ ↔ 学会ページのナビゲーション
- [x] 見やすさの仕上げ（空列削除、セル短縮、モバイル調整、YAML 化など）

### Phase 3: 公開・自動化（1 日）

- [ ] GitHub Actions: push to `main` → `quarto render` → `docs/` deploy
- [ ] PDF を `docs/cv/Chansu_Han_CV.pdf` として artifact も保存
- [ ] GitHub Pages 設定（Source: GitHub Actions）
- [ ] カスタムドメイン（任意）

### Phase 4: 仕上げ（任意）

- [ ] HackMD 旧ページに移行先 URL を追記
- [ ] Google Scholar / ORCID / 所属ページから新 URL へリンク更新
- [x] 学会データの YAML 化（更新効率向上）→ `conferences/data/conferences.yml`
- [ ] 日本語履歴の独立ページ (`/cv/ja`)
- [ ] アクセス解析（Plausible / Google Analytics）

---

## 7. PDF 生成戦略（詳細）

### 方式 A: Quarto → LaTeX → PDF（推奨）

```yaml
# cv/cv-pdf.qmd 冒頭
---
title: "Chansu Han, Ph.D."
format:
  pdf:
    documentclass: article
    papersize: a4
    geometry: margin=2cm
    fontsize: 11pt
    include-in-header: styles/cv-latex-header.tex
---
```

- 長所: 学術 CV として体裁が安定、ページ分割制御しやすい
- 短所: LaTeX セットアップが必要

### 方式 B: Quarto → HTML → Chrome headless PDF

- 長所: Web と見た目を完全一致させやすい
- 短所: ページ数・改ページの制御が LaTeX より難しい

### 方式 C: 別途 moderncv LaTeX テンプレート

- 長所: 最も「伝統的な」学術 CV PDF
- 短所: Web 版と内容の二重管理

**推奨:** 当面は **方式 A**。Web 版と PDF 版で同じ `.qmd` 断片を `{{< include >}}` で共有する。

---

## 8. CI/CD 概要

```yaml
# .github/workflows/deploy.yml（概念）
name: Deploy Site
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: quarto-dev/quarto-actions/setup@v2
      - uses: r-lib/actions/setup-tinytex@v2
      - run: quarto render
      - uses: actions/upload-artifact@v4
        with:
          name: cv-pdf
          path: docs/cv/Chansu_Han_CV.pdf
      - uses: actions/deploy-pages@v4
        # docs/ を GitHub Pages へ
```

---

## 9. HackMD 記法 → Quarto 変換早見表

| HackMD | Quarto / 標準 Markdown |
|---|---|
| `<font size="4">**text**</font>` | `**text**` または `### text` |
| `<details><summary>…</summary>` | `::: {.panel-collapse}` または HTML `<details>` + CSS |
| `:::info … :::` | `::: {.callout-note}` |
| `[name=…]` | YAML `title:` / `author:` |
| HTML `<table>` | Markdown pipe table（可能な範囲） |
| `[\[DOI\]](url)` | `[DOI](url)` |
| Imgur 画像 URL | ローカル `assets/` + `![…](assets/…)` |

---

## 10. 決定事項（2026-07-05 確定）

| # | 項目 | 決定内容 |
|---|---|---|
| 1 | GitHub リポジトリ名 | **`gotchance.github.io`**（ユーザーサイト） |
| 2 | PDF に含める論文 | **全論文**（削るかどうかは後で判断） |
| 3 | メールアドレス | **テキスト表示**: `han@nict.go.jp`（画像は廃止） |
| 4 | 日本語履歴 | 折りたたみ（Phase 1）、別ページは Phase 4 で検討 |
| 5 | 学会テーブルの年列 | **現状 7 年維持**（2027〜2020） |
| 6 | カスタムドメイン | **当面は `gotchance.github.io` のみ**（`.com` は将来検討） |

公開 URL:

- サイト: `https://gotchance.github.io/`
- CV: `https://gotchance.github.io/cv/`
- PDF: `https://gotchance.github.io/cv/Chansu_Han_CV.pdf`（Phase 1）
- 学会情報: `https://gotchance.github.io/conferences/`

---

## 11. 参考サイト・テンプレート

- [Quarto Websites](https://quarto.org/docs/websites/)
- [Quarto PDF](https://quarto.org/docs/output-formats/pdf-basics.html)
- [academicpages.github.io](https://academicpages.github.io/) — Jekyll 系 CV サイトの参考
- [sec-deadlines.github.io](https://sec-deadlines.github.io/) — 学会締切サイトの UI 参考

---

## 12. 次のアクション

1. ~~Phase 0~~ ✅ / ~~Phase 1 実装~~ ✅
2. **ローカルで `quarto preview` 確認 → `docs/` を push**
3. Phase 2 で学会ページを追加
4. Phase 3 で CI 自動化、HackMD からリンク差し替え

### Phase 1 ファイル構成

```
cv/
├── index.qmd              # Web CV（ヘッダー + Download ボタン）
├── cv-pdf.qmd             # PDF 用（xelatex）
├── _content.qmd           # 共通本文（HackMD から変換）
├── assets/profile.jpg
└── (build) cv-pdf.pdf → docs/cv/Chansu_Han_CV.pdf
scripts/render-cv-pdf.sh   # post-render
```

---

*Last updated: 2026-07-18*
