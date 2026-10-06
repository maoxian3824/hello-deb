#!/bin/sh
# build.sh — 一键重新构建 hello-deb_1.0.0_amd64.deb
# 用法: sh build.sh
# 产物会输出到脚本所在目录下的 hello-deb_1.0.0_amd64.deb
set -e

PKG=hello-deb
VER=1.0.0
ARCH=amd64
ROOT="$(cd "$(dirname "$0")" && pwd)"

# 1. 生成包目录结构
rm -rf "$ROOT/$PKG"
mkdir -p "$ROOT/$PKG/DEBIAN" "$ROOT/$PKG/usr/bin"

# 2. 程序本体：安装到 /usr/bin/hello-deb，执行即打印 hello
cat > "$ROOT/$PKG/usr/bin/hello-deb" <<'EOF'
#!/bin/sh
# hello-deb — minimal demo program for the hello-deb package
echo "hello"
EOF

# 3. 控制信息：声明 amd64 架构
cat > "$ROOT/$PKG/DEBIAN/control" <<'EOF'
Package: hello-deb
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Your Name <you@example.com>
Installed-Size: 4
Description: A simple hello demo package
 This package installs /usr/bin/hello-deb, a small script
 that prints "hello" to standard output.
EOF

# 4. 安装后脚本（可选）：保证可执行权限
cat > "$ROOT/$PKG/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
exit 0
EOF

# 5. 修正权限：可执行文件必须 755，control 必须 644
chmod 755 "$ROOT/$PKG/usr/bin/hello-deb" "$ROOT/$PKG/DEBIAN/postinst"
chmod 644 "$ROOT/$PKG/DEBIAN/control"

# 6. 打包（--root-owner-group 保证包内文件属主为 root/root）
dpkg-deb --build --root-owner-group "$ROOT/$PKG" "$ROOT/${PKG}_${VER}_${ARCH}.deb"

echo "构建完成: $ROOT/${PKG}_${VER}_${ARCH}.deb"
