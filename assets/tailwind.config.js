module.exports = {
  purge: ['css/*', '../lib/techstack_news_web/**/*.html.eex', '../lib/techstack_news_web/**/*.html.leex'],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
    fontFamily: {
      title: ['Fira Sans Condensed'],
      sans: ["Open Sans", "ui-sans-serif", "system-ui", "-apple-system", "BlinkMacSystemFont", "Segoe UI", "Roboto", "Helvetica Neue", "Arial", "Noto Sans","sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"]
    }
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
