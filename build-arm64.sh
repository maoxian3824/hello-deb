#!/bin/sh
# build-arm64.sh — 构建 arm64 (aarch64) 架构的 deb 包
set -e

PKG=hello-deb
VER=1.0.0
ARCH=arm64
ROOT="$(cd "$(dirname "$0")" && pwd)"

rm -rf "$ROOT/$PKG-arm64"
mkdir -p "$ROOT/$PKG-arm64/DEBIAN" "$ROOT/$PKG-arm64/usr/bin"

cat > "$ROOT/$PKG-arm64/usr/bin/hello-deb" <<'INNER'
#!/bin/sh
# hello-deb — minimal demo program for the hello-deb package (arm64)
echo "hello"
INNER

cat > "$ROOT/$PKG-arm64/DEBIAN/control" <<'INNER'
Package: hello-deb
Version: 1.0.0
Section: utils
Priority: optional
Architecture: arm64
Maintainer: maoxian3824 <maoxian3824@users.noreply.github.com>
Installed-Size: 4
Description: A simple hello demo package for arm64
 This package installs /usr/bin/hello-deb, a small POSIX shell
 script that prints "hello" to standard output.
INNER

cat > "$ROOT/$PKG-arm64/DEBIAN/postinst" <<'INNER'
#!/bin/sh
set -e
exit 0
INNER

chmod 755 "$ROOT/$PKG-arm64/usr/bin/hello-deb" "$ROOT/$PKG-arm64/DEBIAN/postinst"
chmod 644 "$ROOT/$PKG-arm64/DEBIAN/control"

dpkg-deb --build --root-owner-group "$ROOT/$PKG-arm64" "$ROOT/${PKG}_${VER}_${ARCH}.deb"
echo "构建完成: $ROOT/${PKG}_${VER}_${ARCH}.deb"
