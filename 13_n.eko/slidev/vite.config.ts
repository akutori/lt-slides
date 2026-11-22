import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    // cloudflared の quick tunnel 経由のアクセスを許可する
    allowedHosts: ['.trycloudflare.com'],
  },
})
