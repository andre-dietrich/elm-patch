# elm-patch

> __Use it with caution and not for publishing packages, thus only if you need this functionality in your final application and there is no better way of using ports or running local web-servers...__

This projects contains two patches:

* `patch/Url.elm.patch`: adds additional protocols to URLs, which might be useful
  if you are writing a desktop-app or working with other browsers:

  - `file://`
  - `ftp://`
  - `ipfs://`
  - `ipns://`
  - `hyper://`
  - `dat://`
  
* `patch/VirtualDom.js.patch`: allows to add `onclick` events and `innerHtml`

* `patch/Debug.elm.patch` and `patch/Debug.js.patch`: extends `Debug` with
  `time`, `timeLog`, `timeEnd`, `profile`, and `profileEnd`, for timing and
  CPU-profiling values inline in a pipeline

* `patch/Performance.elm.patch`, `patch/Performance.js.patch`, and
  `patch/CoreElmJson.patch`: adds a new `Performance` module (`mark`,
  `measure`, `clearMark`, `clearMarks`, `clearMeasure`, `clearMeasures`)
  backed by the browser's `Performance` API, and exposes it in `elm/core`'s
  `elm.json` so it can be imported

* `patch/Regex.js.patch` (`elm/regex` 1.0.0): caches compiled `RegExp`
  objects by `(flags, pattern)` in `Elm.Kernel.Regex`. Without this,
  `Regex.fromString`/`fromStringWith` recompile the native regex on every
  single call -- cheap if you bind the result to a top-level constant like
  the docs tell you to, expensive if `fromString` ends up inside a function
  that runs repeatedly (a `view`, a per-keystroke validator, a decoder used
  in a loop). The patch is purely additive (a cache lookup before the
  existing `new RegExp(...)` call) and does not change behavior for correct
  usage.

  Benchmarked (Node, warmed-up V8, median of 9 runs): recompiling the same
  pattern 50k times vs. hitting the cache --
  - simple pattern: 4.82ms → 0.02ms (~245x)
  - email-validation pattern: 18.3ms → 0.42ms (~44x)
  - 13-way alternation: 12.0ms → 0.42ms (~29x)

  In a realistic end-to-end Elm program that also does the actual regex
  matching per call (not just compiling), the win is smaller since matching
  dominates: ~1.5-1.7x measured over 10k-50k naive `fromString` calls.

  Caveat: cached `RegExp` instances are shared, mutable objects (`lastIndex`).
  `Regex.find`/`split` already save+restore `lastIndex` around their exec
  loops, so this is safe for normal usage -- the same safety property a
  hand-written top-level `Regex.Regex` constant already has today, since
  that's a single shared instance too.

* `patch/Scheduler.js.patch` + `patch/Platform.js.patch` (`elm/core` 1.0.5):
  replaces `Array.prototype.shift()` with an index-pointer based dequeue in
  `_Scheduler_queue` (process scheduler) and `_Platform_effectsQueue`
  (Cmd/Sub dispatch queue). `shift()` is O(n) -- it moves every remaining
  element down by one -- so draining a queue that briefly holds n entries
  (e.g. n processes spawned at once via `Cmd.batch` over many
  `Task.perform`/`Process.spawn`) costs O(n^2) overall. The patch is
  behavior-preserving: same drain order, same semantics, only the dequeue
  strategy changes.

  Benchmarked (Node, spawning n concurrent processes via
  `Cmd.batch (List.map ... Task.perform)`, median of 5 runs):

  | n processes | unpatched | patched | speedup |
  |---|---|---|---|
  | 1,000 | 3.33ms | 2.97ms | 1.12x |
  | 20,000 | 178.9ms | 71.5ms | 2.50x |
  | 50,000 | 1,170.0ms | 165.5ms | 7.07x |
  | 100,000 | 4,941.7ms | 423.8ms | 11.66x |

  Scaling matches the theory almost exactly: unpatched time roughly
  quadruples when n doubles (O(n^2)), patched time roughly doubles (O(n)).
  Below a few thousand concurrent processes the difference is negligible.

## Usage

If you are on Linux, a simple `make` should do the job, then simply remove the
`elm-stuff` folder or anything that is cached, such as with parcel the `.cached`
folder and rebuild your entire project.

If you are on Windows or Mac, you will probably have to change the directories
within the local Makefile.

If you only want o apply the Url patch, then run `make Url` and for the other
one `make VirtualDom`...

### Manual Usage

This works on Linux, on Windows or Mac you will have to change the root-folders

``` bash
# Virtual DOM patch
rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/artifacts.dat
rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/docs.json
patch -uN ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.patch

# URL patch
rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/artifacts.dat
rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/docs.json
patch -uN ~/.elm/0.19.1/packages/elm/url/1.0.0/src/Url.elm patch/Url.elm.patch

# Regex caching patch
rm -f ~/.elm/0.19.1/packages/elm/regex/1.0.0/artifacts.dat
rm -f ~/.elm/0.19.1/packages/elm/regex/1.0.0/docs.json
patch -uN ~/.elm/0.19.1/packages/elm/regex/1.0.0/src/Elm/Kernel/Regex.js patch/Regex.js.patch

# Scheduler/Platform queue patch
rm -f ~/.elm/0.19.1/packages/elm/core/1.0.5/artifacts.dat
rm -f ~/.elm/0.19.1/packages/elm/core/1.0.5/docs.json
patch -uN ~/.elm/0.19.1/packages/elm/core/1.0.5/src/Elm/Kernel/Scheduler.js patch/Scheduler.js.patch
patch -uN ~/.elm/0.19.1/packages/elm/core/1.0.5/src/Elm/Kernel/Platform.js patch/Platform.js.patch
```
