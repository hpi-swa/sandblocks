# Sandblocks

[![Latest Release][latest_badge]][latest_download] [![Build Status][gh_action_badge]][gh_action]

A block-based editor for Squeak/Smalltalk.

> This is a research prototype. Hiccups during usage are very much expected. Save often.

![The sandblocks editor](https://raw.githubusercontent.com/hpi-swa/sandblocks/master/screenshots/sandblocks.png)

### Installing
You can either directly use the [latest release][latest_download] or install it in your Squeak 5.3 or trunk image as shown below.

To install it in an existing image, run:
```smalltalk
Metacello new
  baseline: 'Sandblocks';
  repository: 'github://hpi-swa/Sandblocks:master/packages';
  load: #tutorial.

SBEditor openExample.

" Extend the default browser with a block display mode:
  (if you pass `true` it will be the default mode) "
CodeHolder addSandblocksDefault: false.

" Note: By default squeak absorbs ctrl+up/down for scrolling.
        You can turn this off with this line:  "
HandMorph synthesizeMouseWheelEvents: false.
```

### Publications
To cite this work, please use the [workshop paper presented at PX'20](https://doi.org/10.1145/3397537.3397560).

#### 2020
* Tom Beckmann, Stefan Ramson, Patrick Rein, and Robert Hirschfeld. 2020. Visual design for a tree-oriented projectional editor. In Conference Companion of the 4th International Conference on Art, Science, and Engineering of Programming (‹Programming› '20). Association for Computing Machinery, New York, NY, USA, 113–119. [![doi][px20_doi]][px20_paper] [![Preprint][preprint]][px20_pdf]
* Tom Beckmann. 2020. Efficient editing in a tree-oriented projectional editor. In Conference Companion of the 4th International Conference on Art, Science, and Engineering of Programming (‹Programming› '20). Association for Computing Machinery, New York, NY, USA, 215–216. [![doi][px20_src_doi]][px20_src_paper]

[preprint]: https://img.shields.io/badge/preprint-download-blue.svg
[px20_doi]: https://img.shields.io/badge/doi-10.1145/3397537.3397560-blue.svg
[px20_pdf]: https://www.hpi.uni-potsdam.de/hirschfeld/publications/media/BeckmannRamsonReinHirschfeld_2020_VisualDesignForATreeOrientedProjectionalEditor_AcmDL.pdf
[px20_paper]: https://doi.org/10.1145/3397537.3397560
[px20_src_doi]: https://img.shields.io/badge/doi-10.1145/3397537.3398477-blue.svg
[px20_src_paper]: https://doi.org/10.1145/3397537.3398477
[latest_badge]: https://img.shields.io/github/v/release/hpi-swa/sandblocks
[latest_download]: https://github.com/hpi-swa/sandblocks/releases/latest/download/sandblocks-all.zip
[gh_action]: https://github.com/hpi-swa/sandblocks/actions
[gh_action_badge]: https://img.shields.io/github/workflow/status/hpi-swa/sandblocks/smalltalkCI
