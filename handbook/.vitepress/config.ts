import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Handbook - Colorful Pandas",
  description: "The Colorful Pandas handbook",
  themeConfig: {
    nav: [
      { text: "Home", link: "/" },
      { text: "Engineering", link: "/engineering" },
    ],

    sidebar: {
      "/engineering/": [
        {
          text: "Platform",
          items: [],
        },
      ],
    },

    socialLinks: [
      {
        icon: "github",
        link: "https://github.com/cschmatzler/colorful-pandas",
      },
    ],
  },
});
