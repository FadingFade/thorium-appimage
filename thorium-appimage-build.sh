#!/bin/sh

APP="thorium-browser"
VERSION=128.0.6613.189

wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O ./appimagetool
chmod +x ./appimagetool

wget "https://github.com/Alex313031/thorium/releases/download/M${VERSION}/thorium-browser_${VERSION}_SSE3.deb" -O ${APP}.deb
ar x ./${APP}.deb
tar xf ./data.tar.xz
mkdir -p ${APP}.AppDir/usr/bin
mv ./opt/chromium.org/thorium/* ./${APP}.AppDir/usr/bin
mv ./usr/share/applications/thorium-browser.desktop ./${APP}.AppDir/${APP}.desktop
sed -i "s#Exec=/usr/bin/thorium-browser#Exec=thorium-browser#g" ./${APP}.AppDir/${APP}.desktop
sed -i "s#Exec=/usr/bin/thorium-shell#Exec=thorium-shell#g" ./${APP}.AppDir/${APP}.desktop
cp ./${APP}.AppDir/usr/bin/product_logo_256.png ./${APP}.AppDir/${APP}.png
cat <<-'HEREDOC' >> ./${APP}.AppDir/AppRun
#!/bin/sh
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin/:${HERE}/usr/sbin/:${HERE}/usr/games/:${HERE}/bin/:${HERE}/sbin/${PATH:+:$PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib/:${HERE}/usr/lib/i386-linux-gnu/:${HERE}/usr/lib/x86_64-linux-gnu/:${HERE}/usr/lib32/:${HERE}/usr/lib64/:${HERE}/lib/:${HERE}/lib/i386-linux-gnu/:${HERE}/lib/x86_64-linux-gnu/:${HERE}/lib32/:${HERE}/lib64/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export PYTHONPATH="${HERE}/usr/share/pyshared/${PYTHONPATH:+:$PYTHONPATH}"
export XDG_DATA_DIRS="${HERE}/usr/share/${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
export PERLLIB="${HERE}/usr/share/perl5/:${HERE}/usr/lib/perl5/${PERLLIB:+:$PERLLIB}"
export GSETTINGS_SCHEMA_DIR="${HERE}/usr/share/glib-2.0/schemas/${GSETTINGS_SCHEMA_DIR:+:$GSETTINGS_SCHEMA_DIR}"
export QT_PLUGIN_PATH="${HERE}/usr/lib/qt4/plugins/:${HERE}/usr/lib/i386-linux-gnu/qt4/plugins/:${HERE}/usr/lib/x86_64-linux-gnu/qt4/plugins/:${HERE}/usr/lib32/qt4/plugins/:${HERE}/usr/lib64/qt4/plugins/:${HERE}/usr/lib/qt5/plugins/:${HERE}/usr/lib/i386-linux-gnu/qt5/plugins/:${HERE}/usr/lib/x86_64-linux-gnu/qt5/plugins/:${HERE}/usr/lib32/qt5/plugins/:${HERE}/usr/lib64/qt5/plugins/${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
EXEC=$(grep -e '^Exec=.*' "${HERE}"/*.desktop | head -n 1 | cut -d "=" -f 2 | cut -d " " -f 1)
exec "${EXEC}" "$@"
HEREDOC
chmod a+x ./${APP}.AppDir/AppRun
ARCH=x86_64 ./appimagetool --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 20 ./${APP}.AppDir ./${APP}-${VERSION}-x86_64.AppImage
