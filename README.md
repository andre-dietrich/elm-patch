# elm-patch

> __Use it with caution and not for publishing packages, thus only if you need this functionality in your final application and there is no better way of using ports or running local web-servers...__

This projects contains two patches:

* `patch/Url.elm.patch`: adds the FILE protocol to URLs, which might be useful
  if you are writing a desktop-app
* `patch/VirtualDom.js.patch`: allows to add `onclick` events and `innerHtml`

## Usage

If you are on Linux, a simple `make` should do the job, then simply remove the
`elm-stuff` folder or anything that is cached, such as with parcel the `.cached`
folder and rebuild your entire project.

If you are on Windows or Mac, you will probably have to change the directories
within the local Makefile.

If you only want o apply the Url patch, then run `make Url` and for the other
one `make VirtualDom`...
