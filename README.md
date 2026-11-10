# Westside Community Church: Hugo site

A modern rebuild of https://www.westsideky.com/ (content and photos scraped from the Wix site).

## Run locally

```bash
hugo server
```

Then open http://localhost:1313. Build for production with `hugo --gc --minify` (output goes to `public/`).

## Where to edit

| What | File |
|---|---|
| Upcoming events (past dates hide automatically at build time) | `data/events.yaml` |
| Weekly and monthly schedule | `data/schedule.yaml` |
| Leaders and bios | `data/leaders.yaml` |
| Address, phone, giving link, social links, Zoom ID | `hugo.toml` → `[params]` |
| Navigation | `hugo.toml` → `[menus]` |
| Page text | `content/*.md` |
| Photos | `assets/images/` (Hugo resizes them to responsive WebP) |
| Styles | `assets/css/main.css` |

Shortcodes for page content: `feature` (photo + text row), `gallery`, `cards`/`card`.

Old Wix URLs (`/about-3`, `/team-4`, `/about-2`, `/family-discipleship-night`, `/outreach`,
`/westside-comm-park`, `/visit-us`, `/donate-now`) redirect to the new pages through `aliases`.

## Deploy

Pushing to `main` deploys to GitHub Pages: https://seanswiggett.github.io/westside-hugo/
(`.github/workflows/deploy.yml`). The workflow also runs every Monday so past events drop off, and can be run by hand from the repo's Actions tab.

The preview carries `noindex` (set by `HUGO_PARAMS_NOINDEX` in the workflow). When it replaces westsideky.com: remove that env line,
add the custom domain under the repo's Settings → Pages, and point the domain's DNS at GitHub Pages.
