// const lightCodeTheme = require('prism-react-renderer/themes/github');
// const darkCodeTheme = require('prism-react-renderer/themes/dracula');

export default {
  title: "Caacupe",
  url: "https://caacupear.github.io", // Your website URL
  baseUrl: "/alumnos",
  projectName: "caacupear.github.io",
  organizationName: "Caacupe",
  trailingSlash: false,
  onBrokenLinks: "log",
  onBrokenMarkdownLinks: "warn",

  plugins: [["drawio", {}]],

  markdown: {
    mermaid: true
  },

  themes: ["@docusaurus/theme-mermaid"],
  i18n: {
    defaultLocale: "es",
    locales: ["es"]
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: "/", // Serve the docs at the site's root
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: "https://github.com/caacupear/alumnos/tree/main"
        },
        blog: false,
        // blog: {
        //   showReadingTime: true,
        //   readingTime: ({content, frontMatter, defaultReadingTime}) =>
        //     defaultReadingTime({content, options: {wordsPerMinute: 300}}),
        //   // Please change this to your repo.
        //   // Remove this to remove the "edit this page" links.
        //   editUrl:
        //     'https://github.com/caacupear/alumnos/tree/main',
        // },
        theme: {
          customCss: require.resolve("./docs/custom.css")
        }
      })
    ]
  ],
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: "Caacupe",
        logo: {
          alt: "Caacupe",
          src: "img/caacupe.png"
        },
        items: [
          {
            type: "docSidebar",
            sidebarId: "configuracion",
            position: "left",
            label: "Configuración"
          },
          {
            type: "docSidebar",
            sidebarId: "inscripcion",
            position: "left",
            label: "Inscripción"
          },
          {
            type: "docSidebar",
            sidebarId: "boletines",
            position: "left",
            label: "Boletines"
          },
          {
            type: "docSidebar",
            sidebarId: "metricas",
            position: "left",
            label: "Metricas"
          },
          // {
          //   to: 'blog',
          //   label: 'Blog',
          //   position: 'right'
          // },
          {
            type: "docSidebar",
            sidebarId: "diccionario",
            position: "right",
            label: "Diccionarios"
          }
        ]
      },
      footer: {
        style: "dark",
        links: [
          {
            title: "Apis",
            items: [
              // {
              //   label: 'Portabilidad',
              //   to: '/docs/intro',
              // },
            ]
          },
          {
            title: "Arquitectura",
            items: []
          },
          {
            title: "Standards",
            items: []
          }
        ]
      }
      // prism: {
      //   theme: lightCodeTheme,
      //   darkTheme: darkCodeTheme,
      // },
    })
};
