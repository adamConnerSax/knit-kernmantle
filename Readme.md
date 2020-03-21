# knit-kernmantle v0.1.0.0

[![Build Status][travis-badge]][travis]
[![Hackage][hackage-badge]][hackage]
[![Hackage Dependencies][hackage-deps-badge]][hackage-deps]


## Introduction
knit-kernmantle is an attempt to emulate parts of the RMarkdown/knitR experience in haskell. 
The idea is to be able to build HTML (or, perhaps, some other things [Pandoc](http://hackage.haskell.org/package/pandoc) can write) 
inside a haskell executable.  
This package wraps Pandoc and the 
[PandocMonad](http://hackage.haskell.org/package/pandoc-2.7.2/docs/Text-Pandoc-Class.html#t:PandocMonad), 
has logging facilities and support for inserting [hvega](http://hackage.haskell.org/package/hvega), 
[diagrams](https://hackage.haskell.org/package/diagrams), and 
[plots](https://hackage.haskell.org/package/plots) based 
visualizations.  
All of that is handled via writer-like effects, so additions to the documents can be interspersed with regular haskell code. 

As of version 0.1.0.0, the effect stack includes:

## Supported Inputs
* [markdown](https://pandoc.org/MANUAL.html#pandocs-markdown)
* HTML ([blaze](http://hackage.haskell.org/package/blaze-html), [lucid](http://hackage.haskell.org/package/lucid) or Text)
* [latex](https://en.wikipedia.org/wiki/LaTeX)
* [colonnade tables](https://hackage.haskell.org/package/colonnade)
* [hvega](http://hackage.haskell.org/package/hvega) visualizations (via [blaze](http://hackage.haskell.org/package/blaze-html) HTML) 
* [Diagrams](https://archives.haskell.org/projects.haskell.org/diagrams/) (via Diagrams SVG backend, inserted as HTML) 

## Examples
There are a few examples in the "examples" directory.  
* [SimpleExample](https://github.com/adamConnerSax/knit-haskell/blob/master/examples/SimpleExample.hs) 
demonstrates the bare bones features of the library.  Creating a document from a few fragments and then 
"knitting" it into HTML text and writing that to a file. This includes hvega, diagrams and plots examples.

## Notes
* You should be able to get everything you need by just importing the 
[Knit.Report](https://github.com/adamConnerSax/knit-haskell/blob/master/src/Knit/Report.hs) 
module.  This re-exports the main functions for "knitting" documents and re-exports 
all the required functions to input the supported fragment types and create/write Html, as well as various utilties and
combinators for logging, using the cache facility, or throwing errors.
* This uses [kernmantle](https://github.com/YPares/kernmantle#readme), an arrow-based effect system,
for its effect management rather than a monadic effects system like mtl or polysemy.  
* Pandoc effects and writer effects for document building are provided.
* If you use knit-haskell via an installed executable, it will find the templates that 
cabal installs.  But if you use from a local build directory and use "cabal new-" or "cabal v2-"
style commands, you will need to run the executable via some "cabal v2-" command as well, e.g.,
"cabal v2-run" (but not "cabal v2-exec") otherwise the 
templates--installed in the nix-style-build store--won't be found.
* Though you can theoretically output to any format Pandoc can 
write--and it would be great to add some output formats!--some 
features only work with some output formats. 
My goal was the production of Html and that is the only output format that supports hvega charting 
since hvega itself is just a wrapper that builds javascript to render in a browser.  
And so far that is the only supported output format.

[travis]:        <https://travis-ci.org/adamConnerSax/knit-haskell>
[travis-badge]:  <https://travis-ci.org/adamConnerSax/knit-haskell.svg?branch=master>
[hackage]:       <https://hackage.haskell.org/package/knit-haskell>
[hackage-badge]: <https://img.shields.io/hackage/v/knit-haskell.svg>
[hackage-deps-badge]: <https://img.shields.io/hackage-deps/v/knit-haskell.svg>
[hackage-deps]: <http://packdeps.haskellers.com/feed?needle=knit-haskell>
