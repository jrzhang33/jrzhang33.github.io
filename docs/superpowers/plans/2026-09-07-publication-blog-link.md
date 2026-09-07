# Publication Blog Link Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an English `Blog` resource button for the target publication that opens its WeChat article in a new tab.

**Architecture:** Add one static anchor to the target publication's existing `.publication-links` container so the site's current CSS supplies the `Paper`/`Code` button presentation. Add a standard-library HTML parser test that scopes assertions to the publication identified by `data-hf-paper="2608.23392"`.

**Tech Stack:** HTML5, existing CSS, Python 3 standard library (`html.parser`, `unittest`)

## Global Constraints

- Visible label: `Blog`.
- Destination: `https://mp.weixin.qq.com/s/4iRwuybmm45cgHGoWjdi1g`.
- Open in a new tab with `target="_blank"` and `rel="noopener noreferrer"`.
- Place the link immediately before the Hugging Face badge.
- Do not change CSS, JavaScript, or Hugging Face upvote behavior.

---

### Task 1: Add and verify the publication Blog link

**Files:**
- Create: `tests/test_publication_blog_link.py`
- Modify: `index.html:82`

**Interfaces:**
- Consumes: The target publication container marked with `data-hf-paper="2608.23392"` and its `.publication-links` child.
- Produces: A static `Blog` anchor whose URL, browsing context, security relationship, and ordering are covered by a regression test.

- [ ] **Step 1: Write the failing regression test**

```python
from html.parser import HTMLParser
from pathlib import Path
import unittest


class PublicationLinkParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_target = False
        self.target_div_depth = 0
        self.active_link = None
        self.links = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if tag == "div":
            if self.in_target:
                self.target_div_depth += 1
            elif attributes.get("data-hf-paper") == "2608.23392":
                self.in_target = True
                self.target_div_depth = 1
        elif self.in_target and tag == "a":
            self.active_link = {"attrs": attributes, "text": []}

    def handle_data(self, data):
        if self.active_link is not None:
            self.active_link["text"].append(data)

    def handle_endtag(self, tag):
        if tag == "a" and self.active_link is not None:
            self.active_link["text"] = " ".join(
                "".join(self.active_link["text"]).split()
            )
            self.links.append(self.active_link)
            self.active_link = None
        elif tag == "div" and self.in_target:
            self.target_div_depth -= 1
            if self.target_div_depth == 0:
                self.in_target = False


class PublicationBlogLinkTest(unittest.TestCase):
    def test_blog_link_precedes_hugging_face_badge(self):
        page = Path(__file__).parents[1] / "index.html"
        parser = PublicationLinkParser()
        parser.feed(page.read_text(encoding="utf-8"))

        labels = [link["text"] for link in parser.links]
        self.assertIn("Blog", labels)
        blog = parser.links[labels.index("Blog")]
        self.assertEqual(
            blog["attrs"].get("href"),
            "https://mp.weixin.qq.com/s/4iRwuybmm45cgHGoWjdi1g",
        )
        self.assertEqual(blog["attrs"].get("target"), "_blank")
        self.assertEqual(
            set(blog["attrs"].get("rel", "").split()),
            {"noopener", "noreferrer"},
        )

        hf_position = next(
            index for index, label in enumerate(labels) if "Hugging Face" in label
        )
        self.assertLess(labels.index("Blog"), hf_position)


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run the regression test and verify the missing link fails**

Run: `python -m unittest tests/test_publication_blog_link.py -v`

Expected: `FAIL` with `AssertionError: 'Blog' not found`.

- [ ] **Step 3: Add the minimal Blog anchor**

Insert this immediately before the existing Hugging Face anchor in `index.html`:

```html
<a href="https://mp.weixin.qq.com/s/4iRwuybmm45cgHGoWjdi1g"
   target="_blank"
   rel="noopener noreferrer">Blog</a>
```

- [ ] **Step 4: Run verification**

Run: `python -m unittest discover -s tests -v`

Expected: `OK`, including `test_blog_link_precedes_hugging_face_badge`.

Run: `git diff --check`

Expected: no output and exit code `0`.

- [ ] **Step 5: Commit the implementation**

```bash
git add index.html tests/test_publication_blog_link.py
git commit -m "feat: add publication blog link"
```
