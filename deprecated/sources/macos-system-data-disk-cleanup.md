---
type: source
source_type: article
title: "macOS System Data Disk Cleanup — Tools and Techniques"
url: "https://news.ycombinator.com/item?id=47218288"
aliases:
  - "macos disk space"
  - "system data cleanup"
tags:
  - macos
  - disk-management
  - dev-tools
  - cli
source: "Hacker News"
authors: []
date_published: "2026-03-02"
date_captured: "2026-03-02"
summary: >
  Curated tips from an HN thread on reclaiming macOS disk space consumed by
  opaque "System Data." Covers GUI tools (GrandPerspective, DaisyDisk), CLI
  tools (ncdu, dust, du), Finder tricks, and an advanced SIP-disable technique.
word_count: 450
related: []
---

## Problem

macOS "System Data" grows silently — Docker images, music libraries, update caches, Podman VMs — and the OS gives you no way to drill into what's eating the space. A fresh install every year or two is the nuclear option.

## GUI Tools

### GrandPerspective (free, <5MB)
- Treemap visualization of disk usage with color-coded blocks
- Been around 20+ years, actively maintained
- Small footprint — useful even when disk is nearly full
- https://grandperspectiv.sourceforge.net/

### DaisyDisk ($10, one-time)
- Beautiful sunburst-style visualization
- Great for quick visual drill-down
- https://daisydiskapp.com

### OmniDiskSweeper (advanced)
- Run as root with SIP disabled to see everything macOS hides
- Boot into recovery partition → disable SIP → `sudo /Applications/OmniDiskSweeper.app/Contents/MacOS/OmniDiskSweeper`
- Re-enable SIP after inspection

## CLI Tools

### ncdu
```bash
brew install ncdu
ncdu /
```
Interactive ncurses disk usage explorer. Great for drilling into hidden directories like `~/Library`.
- https://dev.yorhel.nl/ncdu

### dust
```bash
brew install dust
dust ~/Library
```
Rust-based `du` alternative with better default output.
- https://github.com/bootandy/dust

### du (built-in)
```bash
du -hs ~/Library/Caches/*
du -hs ~/Library/Containers/*
```
No install needed. Pair with `sort -h` for ranked output.

## Finder Tricks

- **Cmd+J** → enable "Calculate all sizes" (list view only)
- Shows actual directory sizes instead of just "--"
- Check hidden directories: `~/Library`, `~/Library/Caches`, `~/Library/Containers`

## Common Culprits

- **Docker/Podman** — VM disk images in `~/Library/Containers/` (can be 100GB+)
- **Xcode** — derived data, device support files, archives
- **Music production** — sample libraries, project backups
- **Update caches** — macOS installer remnants, app update staging
- **Homebrew** — old formula versions (`brew cleanup`)
