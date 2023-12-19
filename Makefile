all: Url VirtualDom BreakDom

VirtualDom:
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/artifacts.dat
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/docs.json
	patch -uN ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.1.patch

Url:
	rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/artifacts.dat
	rm -f ~/.elm/0.19.1/packages/elm/url/1.0.0/docs.json
	patch -uN ~/.elm/0.19.1/packages/elm/url/1.0.0/src/Url.elm patch/Url.elm.patch

BreakVirtualDom:
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/artifacts.dat
	rm -f ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/docs.json
	patch -uN ~/.elm/0.19.1/packages/elm/virtual-dom/1.0.3/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.2.patch