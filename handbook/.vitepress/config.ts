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
          items: [
            {
              text: "Kubernetes",
              items: [
                {
                  text: "Creating a new cluster",
                  link: "/engineering/platform/kubernetes/create-new-cluster",
                },
              ],
            },
          ],
        },
        {
          text: "ADR",
          items: [
            { text: "000 - Template", link: "/engineering/adr/000-template" },
          ],
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
