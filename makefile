VERSION = 0.1
PKG = gtk+-3.0 json-glib-1.0 webkit2gtk-4.0
SRC = src/*.vala

PKG := $(foreach pkg, $(PKG), --pkg $(pkg))

salty: $(SRC)
	# Generate shared object file, C headers, vapi file and gir file
	valac -o libsalty.so --library salty -H salty.h --gir Salty-$(VERSION).gir -X -shared -X -fPIC $(PKG) $(SRC)
	# Compile typelib file
	g-ir-compiler -o Salty-$(VERSION).typelib --shared-library libsalty Salty-$(VERSION).gir

doc: $(SRC)
	valadoc --force -o doc --package-name salty --package-version $(VERSION) $(SRC) $(PKG)

clean:
	rm -f libsalty.so Salty-$(VERSION).gir Salty-$(VERSION).typelib salty.h salty.vapi
	rm -rf doc
