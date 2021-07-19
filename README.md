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
```
