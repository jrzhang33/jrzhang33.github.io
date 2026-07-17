# Academic Homepage Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish the approved Midnight × Editorial academic homepage while preserving every existing piece of academic information.

**Architecture:** Keep the site as a static GitHub Pages project. `index.html` owns semantic content and structural data attributes, `style.css` owns the responsive visual system, and `script.js` progressively enhances publication filtering and mobile navigation. A dependency-free PowerShell contract test protects content and structural requirements.

**Tech Stack:** HTML5, CSS custom properties and media queries, vanilla JavaScript, PowerShell 7-compatible tests, GitHub Pages.

## Global Constraints

- Preserve all content listed in `docs/superpowers/specs/2026-07-17-academic-homepage-redesign.md`.
- Use a dark research hero and a low-saturation, highly transparent sage-green reading surface.
- Render the exact footer credit `Created by Junru Zhang`.
- Keep the page functional without JavaScript and at widths down to 320 px.
- Add no framework, package manager, build pipeline, fabricated metric, award, citation count, or research claim.

---

### Task 1: Add the static-site contract test

**Files:**
- Create: `tests/site-contract.ps1`
- Test: `tests/site-contract.ps1`

**Interfaces:**
- Consumes: repository-root `index.html`, `style.css`, and optional `script.js`.
- Produces: exit code `0` with `PASS: static site contract` when the required content and implementation hooks are present; exit code `1` with one line per missing requirement otherwise.

- [ ] **Step 1: Write the failing contract test**

Create `tests/site-contract.ps1` with a failure collector, UTF-8 file reads, exact required publication-title checks, structural count checks, and interaction/style hook checks. The core assertions are:

```powershell
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -Raw -Encoding utf8 (Join-Path $root 'index.html')
$css = Get-Content -Raw -Encoding utf8 (Join-Path $root 'style.css')
$scriptPath = Join-Path $root 'script.js'
$script = if (Test-Path $scriptPath) { Get-Content -Raw -Encoding utf8 $scriptPath } else { '' }
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Match([string]$value, [string]$pattern, [string]$message) {
  if ($value -notmatch $pattern) { $script:failures.Add($message) }
}

function Assert-Count([string]$value, [string]$pattern, [int]$expected, [string]$message) {
  $actual = [regex]::Matches($value, $pattern).Count
  if ($actual -ne $expected) { $script:failures.Add("$message (expected $expected, found $actual)") }
}

Assert-Match $html 'Junru Zhang' 'Missing English name'
Assert-Match $html '张君如' 'Missing Chinese name'
Assert-Match $html 'junruzhang@zju\.edu\.cn' 'Missing ZJU email'
Assert-Match $html 'jrzhang1999@gmail\.com' 'Missing Gmail address'
Assert-Match $html 'Created by Junru Zhang' 'Missing approved footer attribution'
Assert-Count $html 'data-research-topic' 5 'Research topic count changed'
Assert-Count $html '<article class="publication" data-year="(?:2023|2024|2025|2026)"' 9 'Selected publication count changed'
Assert-Count $html 'data-publication-filter=' 4 'Publication filter count changed'
Assert-Match $html '<script src="script\.js" defer></script>' 'Missing deferred interaction script'
Assert-Match $css '--color-paper:' 'Missing sage paper color token'
Assert-Match $css '@media \(max-width: 800px\)' 'Missing responsive breakpoint'
Assert-Match $css 'prefers-reduced-motion' 'Missing reduced-motion support'
Assert-Match $script 'data-publication-filter' 'Missing publication filter logic'
Assert-Match $script "setAttribute\('aria-pressed'" 'Filter buttons do not expose state'

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  exit 1
}

Write-Output 'PASS: static site contract'
```

Add exact string assertions for the TimeMaster preprint, all nine selected publication titles, both academic-service headings, Google Scholar, GitHub, LinkedIn, `© 2026 Junru`, and `Last updated May 2026`.

- [ ] **Step 2: Run the contract test and verify RED**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-contract.ps1
```

Expected: exit code `1`, including failures for `Created by Junru Zhang`, `data-research-topic`, selected-publication articles, filter buttons, `script.js`, `--color-paper`, and reduced-motion support.

- [ ] **Step 3: Commit the failing test**

```powershell
git add tests/site-contract.ps1
git commit -m "test: define academic homepage contract"
```

---

### Task 2: Implement the approved static homepage

**Files:**
- Modify: `index.html`
- Modify: `style.css`
- Create: `script.js`
- Test: `tests/site-contract.ps1`

**Interfaces:**
- Consumes: content and links already present in `index.html`; the contract defined in Task 1.
- Produces: semantic section IDs `about`, `research`, `publications`, and `service`; five `data-research-topic` elements; four `data-publication-filter` buttons; nine `<article class="publication" data-year="YYYY">` entries; progressive enhancement through `script.js`.

- [ ] **Step 1: Replace the page shell with the approved semantic structure**

Use this exact top-level order in `index.html`:

```html
<body>
  <header class="hero" id="top">
    <nav class="site-nav" aria-label="Primary navigation">
      <a class="brand" href="#top" aria-label="Junru Zhang home">JZ</a>
      <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="primary-links">Menu</button>
      <div class="nav-links" id="primary-links">
        <a href="#about">About</a>
        <a href="#research">Research</a>
        <a href="#publications">Publications</a>
        <a href="#service">Service</a>
      </div>
    </nav>
    <div class="hero-grid">
      <div class="hero-copy">
        <p class="eyebrow">Final-year PhD · Open to collaboration</p>
        <h1>Junru Zhang <span>张君如</span></h1>
        <p class="position">PhD Student @ ZJU · Visiting @ NTU</p>
      </div>
      <figure class="portrait-card">
        <img src="assets/ruru.jpg" alt="Portrait of Junru Zhang">
      </figure>
    </div>
  </header>
  <main>
    <section class="content-section" id="about" aria-labelledby="about-title"></section>
    <section class="content-section" id="research" aria-labelledby="research-title"></section>
    <section class="content-section" id="publications" aria-labelledby="publications-title"></section>
    <section class="content-section" id="service" aria-labelledby="service-title"></section>
  </main>
  <footer>© 2026 Junru · Created by Junru Zhang · Last updated May 2026</footer>
  <script src="script.js" defer></script>
</body>
```

Fill the four section containers by moving the existing nodes without changing their visible copy: `.bio` goes to `#about`; the five current topic values and the TimeMaster preprint go to `#research`; the nine current selected-publication records and their links go to `#publications`; `.services` goes to `#service`. Give each section the matching heading ID referenced by `aria-labelledby`.

For every external `http` link, add `target="_blank" rel="noopener noreferrer"`. Keep the exact existing URLs and visible academic copy.

- [ ] **Step 2: Implement the approved visual system in `style.css`**

Define these tokens and use them throughout rather than duplicating colors:

```css
:root {
  --color-ink: #10231a;
  --color-ink-soft: #476052;
  --color-hero: #07150f;
  --color-hero-alt: #10291d;
  --color-paper: #f3f8f2;
  --color-paper-deep: #eaf3e9;
  --color-line: rgba(25, 72, 49, 0.14);
  --color-accent: #69d6a2;
  --color-accent-strong: #2a8f62;
}
```

Implement the two-column hero, waveform background, compact topic pills, editorial section grid, highlighted preprint, publication rows, focus states, a max-width content shell, and the approved subtle green gradient. At `max-width: 800px`, hide the desktop nav links behind the menu button, stack the hero and section grids, and collapse publication metadata to one column. At `max-width: 480px`, reduce page padding while preserving a minimum 44 px interactive target.

- [ ] **Step 3: Add progressive filtering and mobile navigation in `script.js`**

Use one DOM-ready initializer with this behavior:

```javascript
const filterButtons = [...document.querySelectorAll('[data-publication-filter]')];
const publications = [...document.querySelectorAll('.publication[data-year]')];

function applyPublicationFilter(filter) {
  publications.forEach((publication) => {
    const year = Number(publication.dataset.year);
    publication.hidden = filter !== 'all' &&
      !(filter === 'earlier' ? year <= 2024 : publication.dataset.year === filter);
  });
}

filterButtons.forEach((button) => {
  button.addEventListener('click', () => {
    filterButtons.forEach((item) => {
      item.setAttribute('aria-pressed', String(item === button));
    });
    applyPublicationFilter(button.dataset.publicationFilter);
  });
});
```

Add a mobile-menu button listener that toggles `aria-expanded` and the navigation list's `data-open` state. Close the menu when a navigation link is selected. Do not hide publications during initial HTML parsing.

- [ ] **Step 4: Run the contract test and verify GREEN**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-contract.ps1
```

Expected: exit code `0` and exactly `PASS: static site contract`.

- [ ] **Step 5: Check formatting and commit the implementation**

Run:

```powershell
git diff --check
```

Expected: exit code `0` with no output.

Then commit:

```powershell
git add index.html style.css script.js
git commit -m "feat: redesign academic homepage"
```

---

### Task 3: Browser verification and publication readiness

**Files:**
- Modify only if verification reveals a defect: `index.html`, `style.css`, `script.js`, `tests/site-contract.ps1`

**Interfaces:**
- Consumes: the completed static site from Task 2.
- Produces: verified desktop and mobile rendering, working publication filters, working mobile navigation, and a clean Git worktree ready to push.

- [ ] **Step 1: Serve the site locally**

Run:

```powershell
python -m http.server 4173 --bind 127.0.0.1
```

Expected: the server listens on port `4173`. Open `http://127.0.0.1:4173/` in a real browser.

- [ ] **Step 2: Verify desktop behavior**

At 1440 × 1000, confirm the portrait is not distorted, the hero copy and contact links fit, the green reading surface is subtle, all nine publications are visible under `All`, `2026` shows four entries, `2025` shows two entries, and `2024 & earlier` shows three entries.

- [ ] **Step 3: Verify mobile behavior**

At 390 × 844 and 320 × 800, confirm there is no horizontal scroll, the mobile menu opens and closes with the correct `aria-expanded` value, every section is reachable, publication rows stack, and the footer credit remains readable.

- [ ] **Step 4: Run final verification**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-contract.ps1
git diff --check
git status --short
```

Expected: contract test passes; diff check has no output; status has no uncommitted implementation files.

- [ ] **Step 5: Push the reviewed branch to GitHub**

Push the branch commit to the GitHub Pages branch only after all prior checks pass:

```powershell
git push origin HEAD:main
```

Expected: a fast-forward update of `origin/main`.
