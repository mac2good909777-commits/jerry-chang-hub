import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// GH Pages 預設路徑；日後註冊網域後改為正式網域
export default defineConfig({
  site: 'https://mac2good909777-commits.github.io',
  base: '/jerry-chang-hub',
  integrations: [sitemap()],
  build: {
    format: 'directory',
  },
});
