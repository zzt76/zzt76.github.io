# Zitian Zhang · Personal website

A responsive academic portfolio built with Jekyll. A biography introduces the researcher, followed by publications and other projects. The site currently uses a light-only theme while dark versions of the research figures are unavailable. No Node.js build step is needed.

## Local preview on Windows

**Double-click `preview.cmd`** in this folder. It checks dependencies, starts Jekyll, and opens **http://127.0.0.1:4000/**. Save your changes and the browser refreshes automatically. Keep the terminal open; press **Ctrl+C** to stop.

Or run from PowerShell:

```powershell
.\dev.ps1 -Open
```

If PowerShell blocks scripts, run `.\preview.cmd`. It sets an execution policy for that process only and does not change your computer's policy.

Ruby and the required gems are already available on this computer. On a fresh Windows computer, install [Ruby+Devkit](https://rubyinstaller.org/) (Ruby 3.3 recommended), enable the PATH option, complete Devkit setup, and reopen the terminal. The launcher installs missing dependencies under the ignored `vendor/bundle/` directory.

Useful commands:

```powershell
.\dev.ps1 -Port 4002 -Open  # another port if 4000 is busy
.\dev.ps1 -Install          # install or repair local dependencies
.\dev.ps1 -Build            # production build in _site/
```

Restart the preview after changing `_config.yml`. Do not open `index.html` directly; Jekyll must render its Liquid templates first.

## Where to edit

| File | Purpose |
| --- | --- |
| `index.html` | Opening biography, availability, and publication sections |
| `_posts/*.markdown` | Publication titles, authors, venues, links, and descriptions |
| `style.scss` | Theme colors, typography, spacing, and responsive layouts |
| `assets/site.js` | Theme preference and keyboard-accessible image viewer |
| `_layouts/default.html` | Shared header, navigation, metadata, and footer |
| `_includes/publication.html` | Publication layout |
| `_includes/project-links.html` | Resource links for each publication |
| `images/` and `pdfs/` | Project figures, portrait, and CV |

Add a publication by copying a research post in `_posts/`, updating its front matter and description, and adding its figure to `images/`. Posts appear newest first. Use `categories: research` for publications. Each post has its own `/projects/:title/` URL; `index.html` is the only homepage.

For other projects, edit `project_type` in the post's front matter to change the label (for example, `project_type: "Game development"` in `_posts/2022-08-17-Oasis.markdown`). The preceding year comes from the post's `date`. Research conference labels come from `venue`.

## Theme and accessibility

The site is pinned to light mode, including on devices using a dark system theme and in browsers with a previously saved dark preference. The theme selector is hidden. To restore the existing Auto / Light / Dark modes after preparing suitable research figures, set `enable_dark_mode: true` in `_config.yml` and restart the preview.

The design includes visible keyboard focus, a skip link, reduced-motion support, responsive layouts, and an image viewer with Escape to close. Fonts come from the operating system, so reading does not depend on an external font service. Google Analytics runs only in production.

## Build and hosting

The site keeps its existing Jekyll/GitHub Pages structure and custom domain. Generated files in `_site/`, Jekyll caches, and installed dependencies are ignored by Git. Commit source files, including `Gemfile` and `Gemfile.lock`, when you are ready to update the live site.

For macOS or Linux with Ruby and Bundler installed:

```sh
bundle install
bundle exec jekyll serve --livereload
# Production build:
JEKYLL_ENV=production bundle exec jekyll build
```

## Credits

Originally based on [Jekyll Now](https://github.com/barryclark/jekyll-now), [Jon Barron's website](https://jonbarron.info/), and [Leonid Keselman's website](https://leonidk.com/). Please respect the copyright of the research content, images, videos, and PDFs.
