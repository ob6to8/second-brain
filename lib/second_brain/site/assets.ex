defmodule SecondBrain.Site.Assets do
  @moduledoc """
  Static assets (CSS + JS) for the generated site, kept as string constants so the
  generator stays dependency-free and produces a fully self-contained bundle.
  """

  @doc "The site stylesheet."
  def css do
    """
    /* Second Brain — knowledge base theme */
    :root {
      --bg: #fbfbfa;
      --bg-elev: #ffffff;
      --bg-sunken: #f3f3f1;
      --text: #1f2328;
      --text-soft: #57606a;
      --text-faint: #8b949e;
      --border: #e4e4e0;
      --accent: #6d4aff;
      --accent-soft: #efeafe;
      --link: #5a3ee0;
      --shadow: 0 1px 3px rgba(20, 20, 40, .06), 0 8px 24px rgba(20, 20, 40, .06);
      --radius: 10px;
      --sidebar-w: 300px;
      --topbar-h: 56px;
      --mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace;
      --sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #0f1115; --bg-elev: #161922; --bg-sunken: #1c2029;
        --text: #e6e6e6; --text-soft: #a9b1bd; --text-faint: #6b7280;
        --border: #262b36; --accent: #9b7bff; --accent-soft: #241f3d;
        --link: #b6a0ff; --shadow: 0 1px 3px rgba(0,0,0,.4), 0 8px 24px rgba(0,0,0,.3);
      }
    }
    :root[data-theme="dark"] {
      --bg: #0f1115; --bg-elev: #161922; --bg-sunken: #1c2029;
      --text: #e6e6e6; --text-soft: #a9b1bd; --text-faint: #6b7280;
      --border: #262b36; --accent: #9b7bff; --accent-soft: #241f3d;
      --link: #b6a0ff; --shadow: 0 1px 3px rgba(0,0,0,.4), 0 8px 24px rgba(0,0,0,.3);
    }
    :root[data-theme="light"] {
      --bg: #fbfbfa; --bg-elev: #ffffff; --bg-sunken: #f3f3f1;
      --text: #1f2328; --text-soft: #57606a; --text-faint: #8b949e;
      --border: #e4e4e0; --accent: #6d4aff; --accent-soft: #efeafe;
      --link: #5a3ee0; --shadow: 0 1px 3px rgba(20,20,40,.06), 0 8px 24px rgba(20,20,40,.06);
    }

    * { box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body {
      margin: 0; background: var(--bg); color: var(--text);
      font-family: var(--sans); font-size: 16px; line-height: 1.65;
      -webkit-font-smoothing: antialiased;
    }
    a { color: var(--link); text-decoration: none; }
    a:hover { text-decoration: underline; }

    .skip-link {
      position: absolute; left: -999px; top: 8px; z-index: 100;
      background: var(--accent); color: #fff; padding: 8px 14px; border-radius: 8px;
    }
    .skip-link:focus { left: 8px; }

    /* Topbar */
    .topbar {
      position: sticky; top: 0; z-index: 40; height: var(--topbar-h);
      display: flex; align-items: center; gap: 14px; padding: 0 16px;
      background: color-mix(in srgb, var(--bg-elev) 88%, transparent);
      backdrop-filter: saturate(1.6) blur(10px);
      border-bottom: 1px solid var(--border);
    }
    .brand { display: flex; align-items: center; gap: 8px; font-weight: 700; color: var(--text); white-space: nowrap; }
    .brand:hover { text-decoration: none; }
    .brand-mark { font-size: 20px; }
    .icon-btn {
      display: inline-flex; align-items: center; justify-content: center;
      width: 38px; height: 38px; border: 1px solid var(--border); border-radius: 9px;
      background: var(--bg-elev); color: var(--text-soft); cursor: pointer; font-size: 17px;
    }
    .icon-btn:hover { color: var(--text); border-color: var(--accent); }
    .nav-toggle { display: none; }

    .search { position: relative; margin-left: auto; flex: 1; max-width: 460px; }
    #search-input {
      width: 100%; height: 40px; padding: 0 14px; font-size: 14px; color: var(--text);
      background: var(--bg-sunken); border: 1px solid var(--border); border-radius: 9px;
    }
    #search-input:focus { outline: none; border-color: var(--accent); background: var(--bg-elev); }
    .search-results {
      position: absolute; top: 46px; right: 0; left: 0; max-height: 70vh; overflow-y: auto;
      background: var(--bg-elev); border: 1px solid var(--border); border-radius: 12px;
      box-shadow: var(--shadow); padding: 6px;
    }
    .search-results a {
      display: block; padding: 9px 11px; border-radius: 8px; color: var(--text);
    }
    .search-results a:hover, .search-results a.sel { background: var(--accent-soft); text-decoration: none; }
    .sr-title { font-weight: 600; font-size: 14px; }
    .sr-desc { font-size: 12.5px; color: var(--text-soft); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .sr-type { font-size: 10.5px; text-transform: uppercase; letter-spacing: .04em; color: var(--text-faint); }
    .sr-empty { padding: 14px; color: var(--text-soft); font-size: 14px; }
    mark { background: color-mix(in srgb, var(--accent) 32%, transparent); color: inherit; border-radius: 3px; }

    /* Layout */
    .layout { display: flex; align-items: flex-start; }
    .sidebar {
      position: sticky; top: var(--topbar-h); align-self: flex-start;
      width: var(--sidebar-w); flex: 0 0 var(--sidebar-w);
      height: calc(100vh - var(--topbar-h)); overflow-y: auto;
      border-right: 1px solid var(--border); padding: 18px 10px 40px;
    }
    .content {
      flex: 1 1 auto; min-width: 0; max-width: 900px; margin: 0 auto;
      padding: 28px 40px 96px;
    }

    /* Nav tree */
    .nav-list { list-style: none; margin: 0; padding: 0; }
    .nav-list .nav-list { margin-left: 12px; padding-left: 8px; border-left: 1px solid var(--border); }
    .nav details > summary {
      list-style: none; cursor: pointer; display: flex; align-items: center; gap: 6px;
      padding: 5px 8px; border-radius: 7px; font-weight: 600; font-size: 14px; color: var(--text);
    }
    .nav details > summary::-webkit-details-marker { display: none; }
    .nav details > summary::before {
      content: "▸"; color: var(--text-faint); font-size: 10px; transition: transform .15s; display: inline-block;
    }
    .nav details[open] > summary::before { transform: rotate(90deg); }
    .nav details > summary:hover { background: var(--bg-sunken); }
    .nav-dir-label { color: inherit; }
    .nav-dir-label:hover { text-decoration: none; }
    .nav-dir-label.active, a.nav-link.active { color: var(--accent); font-weight: 700; }
    .nav-link {
      display: flex; align-items: center; gap: 7px; padding: 5px 8px 5px 22px;
      border-radius: 7px; font-size: 13.5px; color: var(--text-soft);
    }
    .nav-link:hover { background: var(--bg-sunken); color: var(--text); text-decoration: none; }
    a.nav-link.active { background: var(--accent-soft); }
    .type-dot { width: 7px; height: 7px; border-radius: 50%; flex: 0 0 auto; margin-left: auto; background: var(--text-faint); }
    .sidebar-scrim { display: none; }

    /* Breadcrumbs */
    .breadcrumbs { font-size: 13px; color: var(--text-soft); margin-bottom: 18px; }
    .breadcrumbs .sep { color: var(--text-faint); margin: 0 2px; }
    .breadcrumbs [aria-current="page"] { color: var(--text); }

    /* Article */
    .page-header { margin-bottom: 8px; }
    .header-meta { margin-bottom: 10px; }
    .page-title, .concept h1 { font-size: 2rem; line-height: 1.2; margin: 0 0 .3em; letter-spacing: -.01em; }
    .lede { font-size: 1.12rem; color: var(--text-soft); margin: 0 0 1.2em; }
    .concept { font-size: 1rem; }
    .concept h1, .concept h2, .concept h3, .concept h4 { line-height: 1.25; scroll-margin-top: calc(var(--topbar-h) + 12px); }
    .concept h2 { font-size: 1.4rem; margin: 1.8em 0 .5em; padding-bottom: .25em; border-bottom: 1px solid var(--border); }
    .concept h3 { font-size: 1.15rem; margin: 1.5em 0 .4em; }
    .concept h4 { font-size: 1.02rem; margin: 1.3em 0 .3em; }
    .concept p { margin: 0 0 1em; }
    .concept ul, .concept ol { margin: 0 0 1em; padding-left: 1.5em; }
    .concept li { margin: .3em 0; }
    .concept a .anchor, .concept h1 .anchor, .concept h2 .anchor, .concept h3 .anchor, .concept h4 .anchor {
      float: left; margin-left: -1em; padding-right: .35em; color: var(--text-faint);
      opacity: 0; font-weight: 400; text-decoration: none;
    }
    .concept h1:hover .anchor, .concept h2:hover .anchor, .concept h3:hover .anchor, .concept h4:hover .anchor { opacity: 1; }
    .concept code {
      font-family: var(--mono); font-size: .88em; background: var(--bg-sunken);
      padding: .12em .38em; border-radius: 5px; border: 1px solid var(--border);
    }
    .concept pre {
      background: var(--bg-sunken); border: 1px solid var(--border); border-radius: var(--radius);
      padding: 14px 16px; overflow-x: auto; margin: 0 0 1.2em;
    }
    .concept pre code { background: none; border: none; padding: 0; font-size: .86em; }
    .concept blockquote {
      margin: 0 0 1.2em; padding: .2em 1.1em; border-left: 3px solid var(--accent);
      color: var(--text-soft); background: var(--accent-soft); border-radius: 0 8px 8px 0;
    }
    .concept blockquote p:last-child { margin-bottom: 0; }
    .concept hr { border: none; border-top: 1px solid var(--border); margin: 2em 0; }
    .table-wrap { overflow-x: auto; margin: 0 0 1.2em; }
    .concept table { border-collapse: collapse; width: 100%; font-size: .92em; }
    .concept th, .concept td { text-align: left; padding: 8px 12px; border: 1px solid var(--border); }
    .concept th { background: var(--bg-sunken); font-weight: 600; }
    .concept tr:nth-child(even) td { background: color-mix(in srgb, var(--bg-sunken) 45%, transparent); }

    /* Badges & tags */
    .badge {
      display: inline-block; font-size: 12px; font-weight: 600; padding: 2px 9px; border-radius: 999px;
      border: 1px solid var(--border); background: var(--bg-sunken); color: var(--text-soft);
      text-transform: lowercase;
    }
    .type-note    { --tc: #2f81f7; }
    .type-claim   { --tc: #d29922; }
    .type-concept { --tc: #8957e5; }
    .type-reference { --tc: #1a7f37; }
    .type-source  { --tc: #57606a; }
    .type-person  { --tc: #bf3989; }
    .type-project { --tc: #cf222e; }
    .type-area    { --tc: #0969da; }
    .type-snippet { --tc: #6e7781; }
    .type-policy  { --tc: #9a6700; }
    .type-tutorial { --tc: #1f883d; }
    .badge[class*="type-"] {
      color: var(--tc); border-color: color-mix(in srgb, var(--tc) 40%, var(--border));
      background: color-mix(in srgb, var(--tc) 12%, transparent);
    }
    .type-dot[class*="type-"] { background: var(--tc); }

    /* Metadata panel */
    .meta-panel {
      margin-top: 40px; padding: 18px 20px; background: var(--bg-elev);
      border: 1px solid var(--border); border-radius: var(--radius); box-shadow: var(--shadow);
    }
    .meta-panel h2 { font-size: .8rem; text-transform: uppercase; letter-spacing: .06em; color: var(--text-faint); margin: 0 0 14px; }
    .meta-panel dl { margin: 0; display: grid; grid-template-columns: 130px 1fr; gap: 10px 16px; }
    .meta-item { display: contents; }
    .meta-item dt { color: var(--text-faint); font-size: 13px; }
    .meta-item dd { margin: 0; font-size: 14px; word-break: break-word; }
    .meta-item dd code { font-family: var(--mono); font-size: .86em; }
    .verified.yes { color: #1a7f37; font-weight: 600; }
    :root[data-theme="dark"] .verified.yes { color: #3fb950; }
    @media (prefers-color-scheme: dark) { .verified.yes { color: #3fb950; } }
    .verified.no { color: var(--text-faint); }
    .tags { display: flex; flex-wrap: wrap; gap: 6px; }
    .tag {
      font-family: var(--sans); font-size: 12px; padding: 2px 9px; border-radius: 999px;
      background: var(--bg-sunken); border: 1px solid var(--border); color: var(--text-soft);
      cursor: pointer;
    }
    .tag:hover { border-color: var(--accent); color: var(--accent); text-decoration: none; }
    .edges { list-style: none; margin: 0; padding: 0; }
    .edges li { margin: 2px 0; font-size: 14px; }

    /* Responsive */
    @media (max-width: 900px) {
      .nav-toggle { display: inline-flex; }
      .sidebar {
        position: fixed; top: var(--topbar-h); left: 0; z-index: 35;
        transform: translateX(-100%); transition: transform .2s ease;
        background: var(--bg-elev); width: min(86vw, var(--sidebar-w));
      }
      .sidebar.open { transform: translateX(0); box-shadow: var(--shadow); }
      .sidebar-scrim.show { display: block; position: fixed; inset: var(--topbar-h) 0 0 0; z-index: 30; background: rgba(0,0,0,.35); }
      .content { padding: 22px 18px 80px; }
      .brand span:not(.brand-mark) { display: none; }
      .meta-panel dl { grid-template-columns: 100px 1fr; }
    }
    """
  end

  @doc "The site client script (search, theme toggle, mobile nav, tag filter)."
  def js do
    """
    (function () {
      var ROOT = window.SB_ROOT || "";

      // --- theme toggle ---
      var root = document.documentElement;
      try {
        var saved = localStorage.getItem("sb-theme");
        if (saved) root.setAttribute("data-theme", saved);
      } catch (e) {}
      var themeBtn = document.querySelector(".theme-toggle");
      if (themeBtn) themeBtn.addEventListener("click", function () {
        var cur = root.getAttribute("data-theme");
        var isDark = cur ? cur === "dark"
          : window.matchMedia("(prefers-color-scheme: dark)").matches;
        var next = isDark ? "light" : "dark";
        root.setAttribute("data-theme", next);
        try { localStorage.setItem("sb-theme", next); } catch (e) {}
      });

      // --- mobile nav ---
      var sidebar = document.getElementById("sidebar");
      var scrim = document.getElementById("sidebar-scrim");
      var navToggle = document.querySelector(".nav-toggle");
      function closeNav() {
        sidebar && sidebar.classList.remove("open");
        if (scrim) { scrim.classList.remove("show"); scrim.hidden = true; }
        navToggle && navToggle.setAttribute("aria-expanded", "false");
      }
      if (navToggle) navToggle.addEventListener("click", function () {
        var open = sidebar.classList.toggle("open");
        navToggle.setAttribute("aria-expanded", String(open));
        if (scrim) { scrim.hidden = !open; scrim.classList.toggle("show", open); }
      });
      if (scrim) scrim.addEventListener("click", closeNav);

      // --- search ---
      var input = document.getElementById("search-input");
      var box = document.getElementById("search-results");
      var index = null, sel = -1, current = [];

      function load() {
        if (index) return Promise.resolve(index);
        return fetch(ROOT + "search-index.json")
          .then(function (r) { return r.json(); })
          .then(function (d) { index = d; return d; })
          .catch(function () { index = []; return []; });
      }
      function esc(s) { return (s || "").replace(/[&<>]/g, function (c) {
        return { "&": "&amp;", "<": "&lt;", ">": "&gt;" }[c]; }); }
      function score(e, terms) {
        var hay = (e.t + " " + e.g + " " + e.y + " " + e.d + " " + e.x).toLowerCase();
        var s = 0;
        for (var i = 0; i < terms.length; i++) {
          var t = terms[i];
          if (hay.indexOf(t) === -1) return -1;
          if (e.t.toLowerCase().indexOf(t) !== -1) s += 10;
          if (e.g.toLowerCase().indexOf(t) !== -1) s += 5;
          if (e.d.toLowerCase().indexOf(t) !== -1) s += 3;
          s += 1;
        }
        return s;
      }
      function hi(text, terms) {
        var out = esc(text);
        terms.forEach(function (t) {
          if (!t) return;
          var re = new RegExp("(" + t.replace(/[.*+?^${}()|[\\]\\\\]/g, "\\\\$&") + ")", "ig");
          out = out.replace(re, "<mark>$1</mark>");
        });
        return out;
      }
      function render(q) {
        var terms = q.toLowerCase().split(/\\s+/).filter(Boolean);
        if (!terms.length) { box.hidden = true; box.innerHTML = ""; return; }
        current = index
          .map(function (e) { return { e: e, s: score(e, terms) }; })
          .filter(function (r) { return r.s >= 0; })
          .sort(function (a, b) { return b.s - a.s; })
          .slice(0, 20);
        sel = -1;
        if (!current.length) {
          box.innerHTML = '<div class="sr-empty">No matches for “' + esc(q) + '”.</div>';
        } else {
          box.innerHTML = current.map(function (r, i) {
            var e = r.e;
            return '<a href="' + ROOT + e.u + '" data-i="' + i + '">' +
              '<div class="sr-type">' + esc(e.y) + '</div>' +
              '<div class="sr-title">' + hi(e.t, terms) + '</div>' +
              (e.d ? '<div class="sr-desc">' + hi(e.d, terms) + '</div>' : '') +
              '</a>';
          }).join("");
        }
        box.hidden = false;
      }
      function move(d) {
        var links = box.querySelectorAll("a");
        if (!links.length) return;
        if (sel >= 0) links[sel].classList.remove("sel");
        sel = (sel + d + links.length) % links.length;
        links[sel].classList.add("sel");
        links[sel].scrollIntoView({ block: "nearest" });
      }
      if (input) {
        input.addEventListener("focus", load);
        input.addEventListener("input", function () { load().then(function () { render(input.value); }); });
        input.addEventListener("keydown", function (e) {
          if (e.key === "ArrowDown") { e.preventDefault(); move(1); }
          else if (e.key === "ArrowUp") { e.preventDefault(); move(-1); }
          else if (e.key === "Enter") {
            var links = box.querySelectorAll("a");
            if (sel >= 0 && links[sel]) { window.location = links[sel].href; }
            else if (links[0]) { window.location = links[0].href; }
          } else if (e.key === "Escape") { input.blur(); box.hidden = true; }
        });
        document.addEventListener("click", function (e) {
          if (!e.target.closest(".search")) box.hidden = true;
        });
        document.addEventListener("keydown", function (e) {
          if (e.key === "/" && document.activeElement !== input) {
            e.preventDefault(); input.focus();
          }
        });
      }

      // --- tag chips drive the search box ---
      document.querySelectorAll(".tag[data-tag]").forEach(function (btn) {
        btn.addEventListener("click", function () {
          if (!input) return;
          input.value = btn.getAttribute("data-tag");
          input.focus();
          load().then(function () { render(input.value); });
        });
      });
    })();
    """
  end
end
