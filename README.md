# 張現傑中間站（jerry-chang-hub）

個人品牌內容中樞 — Astro + Decap CMS + GitHub Pages。
依《張現傑中間站網站_工作計畫書_v2.0》自動化建置的 MVP 版本。

## 已完成

- ✅ Astro 5 靜態站骨架（Content Collections、RSS、Sitemap）
- ✅ 5 個主要頁面：首頁、關於我、聯繫、3 個分類頁
- ✅ 6 篇首批文章（2 × 3 分類，總字數約 52k 繁中）
- ✅ 文章動態路由 + 麵包屑 + 作者簡介 + 相關文章
- ✅ 睦聚近似視覺 + 三道護欄（不放 Logo、無滿版深藍 Header、金色頻率下修）
- ✅ 響應式導覽列（桌機 sticky / 手機漢堡）
- ✅ Decap CMS 後台設定（/admin/）
- ✅ GitHub Actions 自動部署 workflow
- ✅ SEO（canonical、OG、sitemap）與 favicon

## 立即啟動

```bash
cd /Users/mac2/Documents/Claude-MM4/projects/20260421-jerry-chang-hub
npm install
npm run dev -- --port 4321
# 開 http://127.0.0.1:4321
```

`npm run build` 產出到 `dist/`，可直接部署任何靜態主機。

## 目錄結構

```
src/
├── consts.ts            # 全站常數（聯繫方式、分類、導覽項目）
├── layouts/
│   ├── Base.astro       # 所有頁面外殼
│   └── Article.astro    # 文章內頁
├── components/
│   ├── Nav.astro        # 導覽列（含手機選單）
│   ├── Footer.astro
│   ├── ArticleCard.astro
│   ├── CategoryIndex.astro
│   ├── AuthorBio.astro
│   └── PartnerNote.astro
├── pages/
│   ├── index.astro                    # 首頁
│   ├── about.astro                    # /about/
│   ├── contact.astro                  # /contact/
│   ├── 404.astro
│   ├── industry-data/
│   │   ├── index.astro                # 分類列表
│   │   └── [...slug].astro            # 文章動態路由
│   ├── market-view/{index,[...slug]}.astro
│   └── insights/{index,[...slug]}.astro
├── content/
│   ├── config.ts                      # zod schema（title/date/tags/...）
│   ├── industry-data/*.md             # 產業資訊文章
│   ├── market-view/*.md               # 市場觀察文章
│   └── insights/*.md                  # 其他資訊文章
└── styles/global.css                  # 全站樣式（含 3 分類色票）

public/
├── admin/                             # Decap CMS
│   ├── index.html
│   └── config.yml                     # ← 上線前需改 repo 欄位
├── images/                            # 圖片放這裡
│   └── 2026-04/
└── favicon.svg
```

## 上線前必改（TODO）

### 1. 填入真實聯繫方式 — `src/consts.ts`

```ts
export const SITE = {
  licenseNo: '不動產經紀人｜登錄字號：（請填入）',
  contact: {
    line: 'https://line.me/ti/p/~你的lineID',   // ← 改
    phone: '0900-000-000',                       // ← 改
    email: 'jerry@example.com',                  // ← 改
    fbPage: 'https://www.facebook.com/工業地產筆記',
  },
};
```

### 2. 上傳素材到 `public/images/`

- `profile.jpg`（個人照，可沿用 industrialrepro.github.io/ccw 現有的）
- `line-qr.png`（LINE QR code）
- `jerry-chang.vcf`（vCard，給下載按鈕）
- `og-default.jpg`（OG 預覽圖，1200×630）
- 文章封面圖（可選）

### 3. 設定正式網域 — `astro.config.mjs`

```js
site: 'https://jerrychang.tw',  // ← 改成實際網域
```

### 4. Decap CMS — `public/admin/config.yml`

```yml
backend:
  name: github
  repo: YOUR_GITHUB_USER/jerry-chang-hub   # ← 改成實際 repo
  branch: main
  base_url: https://your-oauth-proxy.example.com
```

Decap OAuth 中繼建議擇一：
- **最快路線**：用 Cloudflare Pages + [decap-proxy](https://github.com/sterlingwes/decap-proxy) Worker（幾乎零成本）。
- **次快**：用 Netlify Identity + git-gateway backend（需改 backend 欄位）。
- **備援**：不用 Decap，直接用 VSCode 改 `src/content/*.md` → `git push`，效果一樣。

### 5. 部署到 GitHub Pages

1. 在 GitHub 建立 Repo（例如 `jerry-chang-hub`）
2. 本地：
   ```bash
   cd /Users/mac2/Documents/Claude-MM4/projects/20260421-jerry-chang-hub
   git init
   git add .
   git commit -m "Initial v2.0 MVP"
   git branch -M main
   git remote add origin git@github.com:YOUR_USER/jerry-chang-hub.git
   git push -u origin main
   ```
3. GitHub Repo → Settings → Pages → Source 選 **GitHub Actions**
4. 首次 push 會自動觸發 `.github/workflows/deploy.yml`，約 2–3 分鐘完成
5. 若使用自訂網域，在 Pages 設定填入網域並在 Cloudflare DNS 加 CNAME

## 已寫好的首批 6 篇文章

| 分類 | Slug | 字數 |
|---|---|---|
| 市場觀察 | 2026-04-tech-migration-south（科技業南移布局） | ~3100 |
| 市場觀察 | 2026-01-central-winter-signals（中部 12–1 月訊號） | ~3000 |
| 其他資訊 | 2026-04-land-change-alert（地籍異動即時通） | ~2100 |
| 其他資訊 | 2026-04-industrial-buy-checklist（買賣前 5 個問題） | ~3200 |
| 產業資訊 | 2026-q1-taichung-industrial（台中 Q1 實登彙整） | ~1700 |
| 產業資訊 | 2026-04-central-science-park-surround（中科擴充區） | ~2000 |

> 文章均依附錄 C 主題規劃撰寫，第一人稱、保守敘述、不虛構精確數字（僅用區間）。
> 上線前建議你親自逐篇校一次，特別是價格區間是否符合你實際掌握的情況。

## 驗收檢查（對照工作計畫書 §15）

| 項目 | 狀態 |
|---|---|
| ① 首屏 10 秒身份辨識 | ✅ Hero + 姓名 + 身份 |
| ④ 無公司官網感 | ✅ 半透明導覽、單人名 brand、簡潔 footer |
| ⑦ 第三方視覺測試 | ⏳ 待 Mac 找 3 位既有客戶盲測 |
| ⑧ Mac 親自發一篇測試文 < 15 分鐘 | ⏳ 上線後透過 /admin/ 走一次 |
| ⑩ 全站只有關於我歷程段出現「睦聚」 | ✅ 已驗證（0 次於其他頁，1 次於 about） |
| ⑪ 三分類頁結構一致 | ✅ 共用 CategoryIndex 元件 |
| ⑫ 首頁最新文章顯示最新 3 篇（跨分類） | ✅ |

## 技術選型風險對策（計畫書 §8.5）

- **Decap CMS 失效** → 備援：VSCode 改 `.md` + `git push`
- **Astro 升級破壞** → 鎖定 Astro 5.x major
- **圖片過大** → 上傳前用 squoosh.app 壓至 WebP，< 300 KB，寬度 ≤ 1200px

## 開發備忘

- 全站字體：Noto Sans TC（中）+ Inter（英數），從 Google Fonts 載入
- 色票：`--c-navy #1E3A5F` / `--c-blue #2B5A8C` / `--c-gold #D97706`
- 分類色：產業資訊 = 深藍 / 市場觀察 = 主藍 / 其他資訊 = 金
- 文章內頁最大寬度 720px（可讀性優先）
- 行高 1.75（內文）/ 1.9（文章）

---

**最後更新**：2026-04-21（自動化建置完成）
