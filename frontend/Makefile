.PHONY: package clean all

gen:
	dart run build_runner build

package:
	cp -r ./build/linux/x64/release/bundle/ loop.AppDir
	cp -r package/ loop.AppDir
	./appimagetool-x86_64.AppImage loop.AppDir loop.AppImage

clean:
	rm -rf loop.AppDir
