# 中間站架構交接文件

> 對象：日後接手維護、修改、或從零重建此網站的人（包含 Mac 本人日後回來看）。
> 建立日期：2026-04-22
> 目前狀態：MVP 骨架完成，尚未上線

---

## 一、一句話說明

這是一個個人品牌內容中樞網站，以 **Astro 5（靜態站生成器）+ Decap CMS（瀏覽器圖形後台）+ GitHub Pages（部署）** 為技術組合，有 v1（個人化）與 v2（編輯式）兩套版型共存，共用同一份文章內容。

---

## 二、專案基本資訊

| 項目 | 內容 |
| --- | --- |
| 專案路徑 | `/Users/mac2/Documents/Claude-MM4/projects/20260421-jerry-chang-hub/` |
| Node 需求 | Node 20+ |
| Astro 版本 | 5.x（已鎖定 major 版本） |
| 部署目標 | GitHub Pages（自訂網域）|
| 目前網域 | 尚未註冊，`astro.config.mjs` 暫填 `jerrychang.tw` |
| 預估年度成本 | NT$800（僅網域費；GitHub Pages / Cloudflare / Decap 皆免費） |

---

## 三、目錄結構（重點檔案）

```
20260421-jerry-chang-hub/
├── README.md                       建置摘要與上線前清單
├── docs/
│   └── HANDOFF-中間站架構.md        本文件
├── astro.config.mjs                網域、sitemap、build 設定
├── package.json                    相依套件與 scripts
├── tsconfig.json
├── .github/workflows/deploy.yml    GitHub Actions 自動部署（push main 觸發）
├── .claude/
│   ├── launch.json                 Claude Preview 伺服器設定
│   └── settings.json               Claude Code 權限設定（見授權那份）
├── public/
│   ├── admin/
│   │   ├── index.html              Decap CMS 後台載入點
│   │   └── config.yml              後台欄位設定、後端設定
│   ├── images/                     圖片媒體（profile、line-qr、文章封面）
│   └── favicon.svg
└── src/
    ├── consts.ts                   聯繫方式、分類、導覽列單一來源
    ├── content/
    │   ├── config.ts               文章 zod schema
    │   ├── industry-data/          產業資訊文章（3 篇）
    │   ├── market-view/            市場觀察文章（2 篇）
    │   └── insights/               其他資訊文章（2 篇）
    ├── styles/
    │   ├── global.css              v1 樣式（個人化、圓角、緊湊）
    │   └── v2.css                  v2 樣式（編輯式、方角、大氣留白）
    ├── layouts/
    │   ├── Base.astro              v1 頁面外殼
    │   ├── Article.astro           v1 文章內頁
    │   ├── V2Base.astro            v2 頁面外殼
    │   └── V2Article.astro         v2 文章內頁
    ├── components/
    │   ├── Nav / Footer / ArticleCard / AuthorBio / PartnerNote / CategoryIndex
    │   └── v2/
    │       └── V2Nav / V2Footer / V2Insight / V2CategoryIndex
    └── pages/
        ├── index.astro             v1 首頁  → /
        ├── about.astro             v1 關於我 → /about/
        ├── contact.astro           v1 聯繫 → /contact/
        ├── 404.astro
        ├── industry-data/index.astro           v1 分類列表
        ├── industry-data/[...slug].astro       v1 文章動態路由
        ├── market-view/...                     同上
        ├── insights/...                        同上
        └── v2/                                 v2 同一套結構鏡像
            ├── index.astro                     /v2/
            ├── about.astro                     /v2/about/
            ├── contact.astro                   /v2/contact/
            ├── industry-data/{index,[...slug]}.astro
            ├── market-view/{index,[...slug]}.astro
            └── insights/{index,[...slug]}.astro
```

**重要**：`src/content/` 底下的文章 **同時被 v1 與 v2 使用** — 改一次兩邊都改。這是故意的設計：內容是資產，版型是外衣。

---

## 四、已完成項目（上線前不用再做）

### 技術面
- Astro 5 專案骨架、Content Collections、RSS-ready、Sitemap
- 動態路由（`/[category]/[slug]/`）與靜態生成（`getStaticPaths`）
- 響應式（640/900/1024 斷點）與手機漢堡選單
- Decap CMS 後台設定（含本機測試模式 `local_backend: true`）
- GitHub Actions deploy workflow（push main 自動 build + 部署）
- SEO：canonical URL、Open Graph、sitemap.xml
- 404 頁、favicon

### 內容面（7 篇首批文章）

| 分類 | Slug | 日期 | 字數 |
| --- | --- | --- | ---: |
| industry-data | 2026-04-dali-industrial-observation | 2026-04-20 | 12,100 |
| industry-data | 2026-04-central-science-park-surround | 2026-04-12 | 2,000 |
| industry-data | 2026-q1-taichung-industrial | 2026-04-05 | 1,700 |
| market-view | 2026-04-tech-migration-south | 2026-04-15 | 3,100 |
| market-view | 2026-01-central-winter-signals | 2026-01-20 | 3,000 |
| insights | 2026-04-industrial-buy-checklist | 2026-04-18 | 3,200 |
| insights | 2026-04-land-change-alert | 2026-04-10 | 2,100 |

### 版型面
- v1 與 v2 共存，右下角懸浮切換按鈕
- 兩版都守三道護欄（不放睦聚 Logo／不做滿版深藍 Header／金色頻率下修）
- 睦聚字眼在全站僅出現於 `/about/` 與 `/v2/about/` 的歷程段各 1 次（驗證通過）

---

## 五、本機開發流程

### 第一次環境準備
```
cd /Users/mac2/Documents/Claude-MM4/projects/20260421-jerry-chang-hub
npm install
```

### 日常開發（開兩個 Terminal）
```
# Terminal A：網站本體
npm run dev                          # → http://localhost:4321/
```
```
# Terminal B（想用 CMS 後台時才需要）：Decap 本機代理
npm run cms                          # → http://localhost:8081
```

### 各頁面網址對照
| 頁面 | v1 | v2 |
| --- | --- | --- |
| 首頁 | `/` | `/v2/` |
| 關於我 | `/about/` | `/v2/about/` |
| 聯繫 | `/contact/` | `/v2/contact/` |
| 產業資訊 | `/industry-data/` | `/v2/industry-data/` |
| 市場觀察 | `/market-view/` | `/v2/market-view/` |
| 其他資訊 | `/insights/` | `/v2/insights/` |
| 後台（dev） | `/admin/index.html` | 同左 |
| 後台（production） | `/admin/` | 同左 |

> **dev 模式的後台必須加 `/index.html`**，production build 就可以直接用 `/admin/`。這是 Astro dev server 對 `public/` 目錄的已知行為差異，不是 bug。

---

## 六、如何新增／編輯文章

### 方法 A — 用 Decap CMS 後台（推薦日常使用）
1. 兩個 Terminal 都跑起來（dev 伺服器 + `npm run cms`）
2. 開 `http://localhost:4321/admin/index.html`
3. 點左側分類（產業資訊／市場觀察／其他資訊）→ 新增文章
4. 填標題、日期、分類（自動）、標籤（從下拉選）、摘要、內文
5. 按「儲存」→ 直接寫入 `src/content/<分類>/<年-月-slug>.md`
6. 回 `http://localhost:4321/` 看效果（Astro 會自動 hot reload）
7. 確認沒問題後 `git add .` → `git commit` → `git push`（才會真正上線）

### 方法 B — 直接改 Markdown 檔（備援／大改時用）
1. 在 `src/content/<分類>/` 新增 `.md` 檔
2. 檔案開頭放 frontmatter（參考現有文章）：
   ```
   ---
   title: "標題"
   date: 2026-04-22
   tags: ["實價登錄", "中彰投"]
   excerpt: "80-120 字摘要"
   author: "張現傑"
   sourceNote: ""
   draft: false
   ---
   ```
3. 寫 Markdown 內文
4. 存檔 → Astro 自動 reload

### 內容規則（務必遵守）
- **分類固定 3 個**，不要新增（計畫書 §6）
- **標籤用既有的**（10 個起步清單），新增前先檢查有無同義
- **第一人稱** for 市場觀察；**冷靜數據** for 產業資訊；**步驟條列** for 其他資訊
- **不放任何物件**（物件走睦聚／瑞禾／591 其他平台）
- **不出現「睦聚」字眼**（`/about/` 歷程段是唯一例外）
- **瑞禾只在頁尾小字與合作說明段**（60–90 字）

---

## 七、如何部署到 GitHub Pages

### 首次上線
1. 在 GitHub 建立 Repo（建議命名 `jerry-chang-hub`）
2. 本地：
   ```
   cd /Users/mac2/Documents/Claude-MM4/projects/20260421-jerry-chang-hub
   git init
   git add .
   git commit -m "Initial v2.0 MVP"
   git branch -M main
   git remote add origin git@github.com:<你的帳號>/jerry-chang-hub.git
   git push -u origin main
   ```
3. GitHub Repo → **Settings → Pages → Source** 選 `GitHub Actions`
4. 首次 push 會自動觸發 `.github/workflows/deploy.yml`，約 2–3 分鐘完成
5. 部署成功後，GitHub 會給一個 `<帳號>.github.io/jerry-chang-hub/` 的網址

### 綁定自訂網域
1. 註冊網域（建議 Cloudflare Registrar，約 NT$800/年的 `.tw`）
2. Cloudflare DNS 加一筆 CNAME 指向 `<帳號>.github.io`
3. GitHub Repo → Settings → Pages → Custom domain 填入網域
4. 等 DNS 生效（5–30 分鐘）
5. 勾選「Enforce HTTPS」
6. 修改 `astro.config.mjs` 的 `site` 為正式網域 → commit → push

### 日常更新
```
# 在本機改好文章後
git add .
git commit -m "新增：2026-04-XX 文章標題"
git push
```
Actions 會自動 build 並重新部署，1–3 分鐘後生效。

---

## 八、上線前必改清單（最後檢查）

| # | 檔案 | 要改什麼 |
| --- | --- | --- |
| 1 | `src/consts.ts` | LINE 網址、電話、Email、FB 粉專、登錄字號 |
| 2 | `public/images/` | 上傳 `profile.jpg`、`line-qr.png`、`jerry-chang.vcf`、`og-default.jpg` |
| 3 | `astro.config.mjs` | `site` 改成實際網域（含 `https://`） |
| 4 | `public/admin/config.yml` | 註解 `local_backend: true`；改 `repo` 與 `base_url`（OAuth proxy） |
| 5 | 全站搜尋 | `Ctrl+F` 搜尋「（請填入）」「YOUR_GITHUB_USER」「0900-000-000」確認沒漏 |

---

## 九、Decap CMS 後台 — 上線的 OAuth 設定

本機開發用 `local_backend: true` 不需 OAuth，但上線後要讓瀏覽器後台能直接寫回 GitHub Repo，必須設 OAuth 中繼。三條路擇一：

### 路線 A：Cloudflare Worker（推薦、零成本）
1. 在 GitHub 建立 OAuth App（Settings → Developer settings → OAuth Apps）
2. Homepage URL 填你的網域；Authorization callback URL 填你的 Worker 網址 + `/callback`
3. 複製 Client ID 與 Client Secret
4. 部署 [decap-proxy](https://github.com/sterlingwes/decap-proxy) Worker，設環境變數
5. 回到 `public/admin/config.yml`：
   ```
   backend:
     name: github
     repo: <你的帳號>/jerry-chang-hub
     branch: main
     base_url: https://<你的worker>.workers.dev
   ```

### 路線 B：Netlify git-gateway（最簡單，但站必須掛 Netlify）
- 改 backend name 為 `git-gateway`
- 不需自建 OAuth App
- 需把站部署到 Netlify（免費）

### 路線 C：不用 CMS，直接 VSCode 改 md + git push
- 刪掉 `public/admin/` 整個資料夾
- 用你習慣的編輯器改 `.md`
- `git push` 即可
- 這是 Decap 失效時的備援方案，也可當長期主力

---

## 十、v1 與 v2 的差異一覽

| 面向 | v1（個人化） | v2（編輯式，CBRE 風） |
| --- | --- | --- |
| 定位 | 溫暖、個人品牌、第一人稱 | 冷靜、機構感、專業權威 |
| Hero | 淺藍漸層 + 雙欄 + 人像卡 | 滿版深色背景（92vh）+ 金色細線 eyebrow |
| 字體 | Noto Sans TC 全站 | 標題 **Noto Serif TC** + 內文 Inter/Noto Sans TC |
| 標題尺寸（首頁 H1） | 40px | 72px（編輯感） |
| 卡片 | 圓角、淺陰影、輕浮動 | 方角、細線切割、hover 變色 |
| 服務區 | 3 張圓角卡 | 3 欄無縫邊線網格（pillars） |
| 區塊間距 | 64px | 140px |
| 導覽列 | 半透明白／滾動後全白 | 黑字 + 金色底線當前項 + 右側 CTA |
| Footer | 單行簡潔 | 4 欄（品牌／服務／關於／聯繫）|
| CTA 按鈕 | 藍色圓角填色 | **金色方角 + 箭頭 hover 位移** |
| 統計 strip | 無 | 4 格大數字白底網格 |
| 雙欄編輯區 | 無 | About / 服務 用 split block |
| 暗色 CTA band | 無 | 有（深藍 + 金漸層）|

**選型建議**：兩個都是完成品，無對錯。若要 soft launch，建議先上 v1（更個人），累積幾個月讀者回饋後再決定是否切 v2。也可長期兩版並存（v2 作為備援或試驗版）。

---

## 十一、內容治理長期規則（摘要）

| 週期 | 工作 | 備註 |
| --- | --- | --- |
| 每月 | 發 1–2 篇新文章 | 低於每月 1 篇會影響回訪 |
| 每季 | 檢視全部文章、合併同義標籤、標註過時內容 | 18 個月以上的市場觀察類加「本文寫於 X 年」小字 |
| 每半年 | 依賴套件更新（`npm outdated` → 審慎升級） | 鎖定 Astro major 版本，不要亂跳 |
| 每半年 | 備份演練（git clone 到新機器、部署到測試網域驗證） | 災難復原信心 |
| 每年 | 網域續約 | 設自動續約與到期提醒 |

---

## 十二、風險與對策（簡表）

| 風險 | 對策 |
| --- | --- |
| 文章斷更 | 維持選題池 ≥ 5 個；連續 2 個月沒發 → 啟動 800 字短文救急 |
| 分類標籤失控 | 每季檢視；新標籤啟用前先搜既有；標籤 < 3 篇合併或移除 |
| Decap CMS 失效 | 備援：VSCode 直接改 `.md` + `git push` |
| Astro 升級破相容 | 鎖定 major；`package-lock.json` 入版控；升級前先建測試分支 |
| 內容被複製 | 每篇文末加「本文首發於 [網域]」；必要時 DMCA 檢舉 |
| SEO 內容重複 | 中間站首發全文；睦聚站同步時只放 300 字摘要 + 連結 + `canonical` |

---

## 十三、一鍵對照表：常用檔案位置

| 需要改什麼 | 去這個檔案 |
| --- | --- |
| 聯繫方式／導覽項目／分類定義 | `src/consts.ts` |
| 全站色票／字體／間距 | `src/styles/global.css`（v1）／`src/styles/v2.css`（v2） |
| 首頁結構／內容 | `src/pages/index.astro`（v1）／`src/pages/v2/index.astro`（v2） |
| 關於我頁 | `src/pages/about.astro` / `src/pages/v2/about.astro` |
| 文章版型 | `src/layouts/Article.astro` / `src/layouts/V2Article.astro` |
| 合作說明段文案 | `src/components/PartnerNote.astro` |
| Decap CMS 欄位／後端 | `public/admin/config.yml` |
| 部署流程 | `.github/workflows/deploy.yml` |

---

## 十四、聯繫（遇到卡住時）

- 原始工作計畫書：`/Users/mac2/Downloads/張現傑中間站網站_工作計畫書_v2.0.docx`
- 建站用的 Skill：`analyze-report`、`brand-style`（如需套用品牌風格變體）
- 遇到技術問題：看 [Astro 官方文件](https://docs.astro.build/) 或 [Decap CMS 文件](https://decapcms.org/docs/)
- 部署失敗：先看 GitHub Repo → Actions 分頁的錯誤訊息

---

**本交接文件結束。**
