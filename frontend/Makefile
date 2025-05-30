.PHONY: package clean all

package:
	dart run build_runner build
	flutter build linux --release
	cp -r ./build/linux/x64/release/bundle/ loop.AppDir
	cp -r package/* loop.AppDir
	./appimagetool-x86_64.AppImage loop.AppDir loop.AppImage

clean:
	rm -rf loop.AppDir
