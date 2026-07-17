# Academic Homepage Redesign

## Goal

Redesign Junru Zhang's one-page GitHub Pages academic homepage into a premium, research-forward site without removing or rewriting the existing academic information.

## Approved Visual Direction

- Use the approved “Midnight × Editorial” composition.
- Keep a dark research-lab hero with a restrained time-series waveform motif.
- Use a very light, low-saturation sage green reading surface below the hero. The tint must remain subtle enough for long-form reading.
- Preserve the existing portrait without retouching or identity changes.
- Use an asymmetric desktop hero and a single-column mobile layout.
- Prefer clear typography, generous spacing, thin dividers, restrained pills, and minimal motion over decorative clutter.

## Information Preservation

The redesign must retain:

- `Junru Zhang (张君如)` and `PhD Student @ ZJU & Visiting @ NTU`.
- Both existing email addresses.
- Google Scholar, GitHub, and LinkedIn links.
- All five research topics.
- Both existing About Me paragraphs and all linked supervisors and institutions.
- The existing TimeMaster preprint, its authors, Paper link, and Code link.
- All nine selected publications, in the existing wording, with their authors, venues, Paper links, and Code links where present.
- The complete Academic Services lists.
- The existing copyright year and last-updated date.

## Interaction

- The header navigation scrolls to About, Research, Publications, and Service.
- Publication filters provide `All`, `2026`, `2025`, and `2024 & earlier` views.
- `All` is selected by default.
- Filtering hides non-matching publication entries without reordering entries.
- The page remains useful when JavaScript is unavailable: every publication is visible by default.
- External links remain standard links and open in a new tab with safe `rel` attributes.

## Responsive and Accessibility Requirements

- The layout must fit at 320 px without horizontal scrolling.
- Navigation collapses cleanly on narrow screens; content remains fully reachable.
- Semantic sections, headings, navigation labels, button states, descriptive link labels, and visible focus styles are required.
- Respect `prefers-reduced-motion`.
- Text and controls must maintain readable contrast on the green content surface and dark hero.

## Attribution

The footer must include the exact public credit `Created by Junru Zhang` alongside `© 2026 Junru` and `Last updated May 2026`.

## Technical Scope

- Keep the site dependency-light and compatible with static GitHub Pages hosting.
- Continue using plain HTML and CSS.
- Add one small plain-JavaScript file for publication filtering and mobile navigation.
- Add a repository-local PowerShell contract test that verifies preserved information, structural hooks, interaction wiring, and footer attribution.
- Do not add a framework, build pipeline, analytics, fabricated metrics, institution logos, citation counts, awards, or research claims.
