all: Url VirtualDom

VirtualDom:
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/artifacts.dat
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/docs.json
	patch -uN ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.2/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.patch

Url:
	rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/artifacts.dat
	rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/docs.json
	patch -uN ~/.elm/0.19.1/packages/elm/url/1.0.0/src/Url.elm patch/Url.elm.patch
