defmodule SecondBrain.MarkdownTest do
  use ExUnit.Case, async: true

  alias SecondBrain.Markdown

  describe "headings" do
    test "renders ATX headings with slug anchors" do
      html = Markdown.to_html("## Why it matters")
      assert html =~ ~s(<h2 id="why-it-matters")
      assert html =~ "Why it matters</h2>"
      assert html =~ ~s(<a class="anchor" href="#why-it-matters")
    end

    test "slug drops punctuation and keeps hyphens" do
      assert Markdown.slug("Divergence: fresh clone vs. baked clone") ==
               "divergence-fresh-clone-vs-baked-clone"
    end

    test "strips an optional closing run of hashes" do
      assert Markdown.to_html("# Title #") =~ ">Title</h1>"
    end
  end

  describe "inline emphasis and code" do
    test "bold, italic, and inline code" do
      html = Markdown.to_html("A **bold**, an *italic*, and `code`.")
      assert html =~ "<strong>bold</strong>"
      assert html =~ "<em>italic</em>"
      assert html =~ "<code>code</code>"
    end

    test "bold can wrap an inner italic" do
      html = Markdown.to_html("**The tree *is* the taxonomy.**")
      assert html =~ "<strong>The tree <em>is</em> the taxonomy.</strong>"
    end

    test "emphasis spans across a code span" do
      html = Markdown.to_html("A **`git fetch`** only updates.")
      assert html =~ "<strong><code>git fetch</code></strong>"
    end

    test "markdown inside a code span is left literal" do
      html = Markdown.to_html("Use `a *b* c` verbatim.")
      assert html =~ "<code>a *b* c</code>"
      refute html =~ "<em>b</em>"
    end

    test "escapes HTML special characters" do
      html = Markdown.to_html("1 < 2 & 3 > 0")
      assert html =~ "1 &lt; 2 &amp; 3 &gt; 0"
    end

    test "escapes HTML inside code spans" do
      assert Markdown.to_html("`a < b`") =~ "<code>a &lt; b</code>"
    end
  end

  describe "links" do
    test "external links pass through" do
      assert Markdown.to_html("[x](https://example.com)") =~
               ~s(<a href="https://example.com">x</a>)
    end

    test "autolinks" do
      assert Markdown.to_html("see <https://example.com/a>") =~
               ~s(<a href="https://example.com/a">https://example.com/a</a>)
    end

    test "bundle-absolute .md links become relative .html with root prefix" do
      html = Markdown.to_html("[OKF](/references/okf.md)", root_prefix: "../../")
      assert html =~ ~s(<a href="../../references/okf.html">OKF</a>)
    end

    test "relative .md links resolve against the source directory" do
      html = Markdown.to_html("[sib](../foo/bar.md)", dir: "SWE/testing", root_prefix: "../../")

      assert html =~ ~s(<a href="../../SWE/foo/bar.html">sib</a>)
    end

    test "in-page anchors pass through untouched" do
      assert Markdown.to_html("[G](#grounding)", root_prefix: "../") =~
               ~s(<a href="#grounding">G</a>)
    end

    test "a link label may contain a code span" do
      html = Markdown.to_html("[`sources/`](/a/b.md)", root_prefix: "")
      assert html =~ ~s(<a href="a/b.html"><code>sources/</code></a>)
    end

    test "fragment on an internal .md link is preserved" do
      html = Markdown.to_html("[x](/a/b.md#sec)", root_prefix: "")
      assert html =~ ~s(<a href="a/b.html#sec">x</a>)
    end

    test "href with & is escaped to valid HTML" do
      assert Markdown.to_html("[x](https://e.com/?a=1&b=2)") =~
               ~s(<a href="https://e.com/?a=1&amp;b=2">x</a>)
    end

    test "a double-quote in an href cannot break out of the attribute" do
      html = Markdown.to_html(~s{[x](https://e.com/a"onmouseover=alert(1))})
      refute html =~ ~s(a"onmouseover)
      assert html =~ "&quot;onmouseover"
    end
  end

  describe "lists" do
    test "nested bullet lists" do
      html = Markdown.to_html("- one\n- two\n  - two-a\n- three")
      assert html =~ "<ul><li>one</li><li>two<ul><li>two-a</li></ul></li><li>three</li></ul>"
    end

    test "ordered lists" do
      assert Markdown.to_html("1. a\n2. b") =~ "<ol><li>a</li><li>b</li></ol>"
    end

    test "wrapped continuation lines fold into the item" do
      html = Markdown.to_html("- first line\n  wrapped\n- next")
      assert html =~ "<li>first line wrapped</li>"
    end
  end

  describe "blocks" do
    test "fenced code block, escaped and language-tagged" do
      html = Markdown.to_html("```elixir\nx < y\n```")
      assert html =~ ~s(<pre><code class="language-elixir">x &lt; y</code></pre>)
    end

    test "blockquotes" do
      assert Markdown.to_html("> quoted\n> more") =~ "<blockquote><p>quoted more</p></blockquote>"
    end

    test "GitHub-style tables" do
      html = Markdown.to_html("| a | b |\n|---|---|\n| 1 | 2 |")
      assert html =~ "<th>a</th><th>b</th>"
      assert html =~ "<td>1</td><td>2</td>"
    end

    test "table column alignment from the separator row" do
      html = Markdown.to_html("| l | c | r |\n|:--|:-:|--:|\n| 1 | 2 | 3 |")
      assert html =~ ~s(<th style="text-align:left">l</th>)
      assert html =~ ~s(<th style="text-align:center">c</th>)
      assert html =~ ~s(<th style="text-align:right">r</th>)
      assert html =~ ~s(<td style="text-align:right">3</td>)
    end

    test "a lone pipe row without a separator is a paragraph, not a hang" do
      assert Markdown.to_html("| Attached to | The env | Your repo |") ==
               "<p>| Attached to | The env | Your repo |</p>"
    end

    test "HTML comments are dropped" do
      assert Markdown.to_html("<!-- hidden -->\n\ntext") == "<p>text</p>"
    end

    test "horizontal rule" do
      assert Markdown.to_html("a\n\n---\n\nb") =~ "<hr />"
    end

    test "paragraphs join wrapped lines" do
      assert Markdown.to_html("one\ntwo") == "<p>one two</p>"
    end
  end
end
