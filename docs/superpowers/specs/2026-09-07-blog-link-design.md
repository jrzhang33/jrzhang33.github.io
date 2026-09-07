# Blog Link Design

## Goal

Add an English `Blog` resource link to the publication “Towards a Densing Law for User Representation Learning at Billion-Scale Capacity.” The link opens the related WeChat article in a new browser tab.

## Design

- Add a standard anchor inside the publication's existing `.publication-links` container, immediately before the Hugging Face badge.
- Use `Blog` as the visible English label.
- Link to `https://mp.weixin.qq.com/s/4iRwuybmm45cgHGoWjdi1g`.
- Set `target="_blank"` and `rel="noopener noreferrer"`.
- Reuse the existing `.publication-links a` presentation so the link matches the site's `Paper` and `Code` resource buttons.
- Do not change CSS, JavaScript, or the Hugging Face upvote behavior.

## Data Flow and Failure Behavior

The browser follows the static anchor directly to the WeChat article. There is no application state or client-side processing. If WeChat is unavailable, the current portfolio page remains open because the destination uses a new tab.

## Verification

- Confirm the publication contains one visible `Blog` link before the Hugging Face badge.
- Confirm its `href`, `target`, and `rel` attributes match the design.
- Run the repository's existing tests, if available.
- Inspect the rendered publication at desktop and narrow viewport widths to ensure the resource row remains readable.
