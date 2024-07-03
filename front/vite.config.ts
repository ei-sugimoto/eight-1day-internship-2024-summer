import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import RubyPlugin from "vite-plugin-ruby";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), RubyPlugin()],
  css: {
    modules: {
      generateScopedName: "[name]__[local]",
    },
  },
  server: {
    watch: {
      usePolling: true,
    },
  },
});
