const sidebar = {
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
            {
              text: "Maintenance Tasks",
              link: "/engineering/platform/kubernetes/maintenance-tasks",
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
};

export default sidebar;
