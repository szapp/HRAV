# Human Readable Access Violations

[![Scripts](https://github.com/szapp/HRAV/actions/workflows/scripts.yml/badge.svg)](https://github.com/szapp/HRAV/actions/workflows/scripts.yml)
[![Validation](https://github.com/szapp/HRAV/actions/workflows/validation.yml/badge.svg)](https://github.com/szapp/HRAV/actions/workflows/validation.yml)
[![Build](https://github.com/szapp/HRAV/actions/workflows/build.yml/badge.svg)](https://github.com/szapp/HRAV/actions/workflows/build.yml)
[![GitHub release](https://img.shields.io/github/v/release/szapp/HRAV.svg)](https://github.com/szapp/HRAV/releases/latest)
[![Support on Ko-fi](https://img.shields.io/badge/ko--fi-support-ff586e?logo=kofi&logoColor=white)](https://ko-fi.com/szapp)  
[![World of Gothic](https://raw.githubusercontent.com/szapp/patch-template/main/.github/actions/initialization/badges/wog.svg)](https://forum.worldofplayers.de/forum/threads/?p=26774926)
[![Spine](https://raw.githubusercontent.com/szapp/patch-template/main/.github/actions/initialization/badges/spine.svg)](https://clockwork-origins.com/spine)
[![Steam workshop](https://img.shields.io/badge/steam-workshop-2a3f5a?logo=steam&labelColor=1b2838)](https://steamcommunity.com/sharedfiles/filedetails/?id=2787341517)

Human Readable Access Violations: Extend the stack trace of access violations to include Daedalus symbols for Gothic 2 NotR (with partial support for Gothic 1).

This is a modular modification (a.k.a. patch or add-on) that can be installed and uninstalled at any time and is virtually compatible with any modification.
It supports <kbd>Gothic 1</kbd> (partially) and <kbd>Gothic II: NotR</kbd>.

<sup>Generated from [szapp/patch-template](https://github.com/szapp/patch-template).</sup>

## About

This patch offers more insight into crashes by showing symbol names and byte offsets for script induced access violation errors.

Access violations may differ in their stack traces and register information.
The information within can be valuable to developers to fix bugs.
However, this information is not very accessible and depending on the circumstance not easy to decode.

This patch makes this valuable information available.
Users of this patch may contribute by sending access violation screenshots to mod-developers.
This helps them to get to the bottom of game crashes more easily and, in turn, provide faster support.

&nbsp;

<div align="center">
<img src="https://github.com/szapp/HRAV/assets/20203034/03f04331-af9e-4471-a532-370fc2df1933" alt="Screenshot" />
</div>

## Disclaimer

I had written this patch quite a while ago and never finalized it.
Some byte-offset may be slightly off.
It clarifies the stack trace for script functions only.

The patch follows a manual procedure described here [2].
The uncovered Daedalus stack trace is inferior (incomplete and less accurate) to Ikarus's stack trace printed to the zSpy.
If access to the zSpy is possible, it should be preferred. The "Human Readable Access Violations" is therefore merely a small aid.

## Links

[1] https://forum.worldofplayers.de/forum/threads/?p=26774926  
[2] https://forum.worldofplayers.de/forum/threads/?p=25925207

## Installation

1. Download the latest release of `HRAV.vdf` from the [releases page](https://github.com/szapp/HRAV/releases/latest).

2. Copy the file `HRAV.vdf` to `[Gothic]\Data\`. To uninstall, remove the file again.

The patch is also available on
- [World of Gothic forum post](https://forum.worldofplayers.de/forum/threads/?p=26774926)
- [Spine Mod-Manager](https://clockwork-origins.com/spine/)
- [Steam Workshop Gothic 2](https://steamcommunity.com/sharedfiles/filedetails/?id=2787341517)

### Requirements

<table><thead><tr><th>Gothic</th><th>Gothic II: NotR</th></tr></thead>
<tbody><tr><td><a href="https://www.worldofgothic.de/dl/download_34.htm">Version 1.08k_mod</a></td><td><a href="https://www.worldofgothic.de/dl/download_278.htm">Report version 2.6.0.0</a></td></tr></tbody>
<tbody><tr><td colspan="2" align="center"><a href="https://github.com/szapp/Ninja/wiki#wiki-content">Ninja 4</a> or higher</td></tr></tbody>
<tbody><tr><td colspan="4" align="center"><a href="https://github.com/szapp/Toolkit">Toolkit 16</a> or higher</td></tr></table>

<!--

If you are interested in writing your own patch, please do not copy this patch!
Instead refer to the PATCH TEMPLATE to build a foundation that is customized to your needs!
The patch template can found at https://github.com/szapp/patch-template.

-->
