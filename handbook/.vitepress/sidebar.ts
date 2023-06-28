const sidebar = {
  "/engineering/": [
    {
      text: "Platform",
      items: [
        {
          text: "Kubernetes",
          items: [
            {
              text: "Maintenance Tasks",
              link: "/engineering/platform/kubernetes/maintenance-tasks",
            },
          ],
        },
      ],
    },
    {
      text: "Tooling",
      items: [
        {
          text: "Grafana Cloud",
          link: "/engineering/tooling/grafana-cloud",
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
};

export default sidebar;
