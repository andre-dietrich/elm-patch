# Use ELM_HOME if set, otherwise default to ~/.elm
ELM_HOME ?= ~/.elm

.PHONY: all

all: echo_elm_home Url VirtualDom BreakVirtualDom

echo_elm_home:
	echo "ELM_HOME is set to $(ELM_HOME)"

VirtualDom:
	rm -f $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/artifacts.dat
	rm -f $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/docs.json
	patch -uN $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.1.patch

Url:
	rm -f $(ELM_HOME)/0.19.1/packages/elm/url/1.0.0/artifacts.dat
	rm -f $(ELM_HOME)/0.19.1/packages/elm/url/1.0.0/docs.json
	patch -uN $(ELM_HOME)/0.19.1/packages/elm/url/1.0.0/src/Url.elm patch/Url.elm.patch

BreakVirtualDom:
	rm -f $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/artifacts.dat
	rm -f $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/docs.json
	patch -uN $(ELM_HOME)/0.19.1/packages/elm/virtual-dom/1.0.3/src/Elm/Kernel/VirtualDom.js patch/VirtualDom.js.2.patch

