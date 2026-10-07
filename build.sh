#!/bin/sh
# build.sh — 一键构建 hello-deb deb 包
# 用法: sh build.sh [amd64|arm64]   默认 amd64
# 产物会输出到脚本所在目录下的 hello-deb_<version>_<arch>.deb
set -e

PKG=hello-deb
VER=1.0.0
ARCH=${1:-amd64}
ROOT="$(cd "$(dirname "$0")" && pwd)"
DIR="$ROOT/$PKG-$ARCH"

case "$ARCH" in
  amd64|arm64) ;;
  *) echo "用法: sh build.sh [amd64|arm64]" >&2; exit 1 ;;
esac

# 1. 生成包目录结构
rm -rf "$DIR"
mkdir -p "$DIR/DEBIAN" "$DIR/usr/bin"

# 2. 程序本体：安装到 /usr/bin/hello-deb，执行即打印 hello
cat > "$DIR/usr/bin/hello-deb" <<'EOF'
#!/bin/sh
# hello-deb — minimal demo program for the hello-deb package
echo "hello"
EOF

# 3. 控制信息：声明架构
cat > "$DIR/DEBIAN/control" <<EOF
Package: $PKG
Version: $VER
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: maoxian3824 <maoxian3824@users.noreply.github.com>
Installed-Size: 4
Description: A simple hello demo package
 This package installs /usr/bin/hello-deb, a small POSIX shell
 script that prints "hello" to standard output.
EOF

# 4. 修正权限：可执行文件必须 755，control 必须 644
chmod 755 "$DIR/usr/bin/hello-deb"
chmod 644 "$DIR/DEBIAN/control"

# 5. 打包（--root-owner-group 保证包内文件属主为 root/root）
dpkg-deb --build --root-owner-group "$DIR" "$ROOT/${PKG}_${VER}_${ARCH}.deb"

echo "构建完成: $ROOT/${PKG}_${VER}_${ARCH}.deb"
