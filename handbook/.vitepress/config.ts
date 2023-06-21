import { defineConfig } from "vitepress";
import sidebar from "./sidebar";

export default defineConfig({
  title: "Handbook - Colorful Pandas",
  description: "The Colorful Pandas handbook",
  themeConfig: {
    search: {
      provider: "local",
    },

    nav: [
      { text: "Home", link: "/" },
      { text: "Engineering", link: "/engineering" },
    ],

    sidebar: sidebar,

    socialLinks: [
      {
        icon: "github",
        link: "https://github.com/cschmatzler/colorful-pandas",
      },
    ],
  },
});
