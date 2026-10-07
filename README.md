# hello-deb

一个最小的 Debian 打包示例，提供 **amd64 (x64)** 与 **arm64 (aarch64)** 两种架构的 deb 包。

安装后提供 `/usr/bin/hello-deb` 命令，执行即输出 `hello`。

## 下载

| 架构 | 适用设备 | 下载 |
|---|---|---|
| amd64 (x64) | 普通 PC / 服务器 | [v1.0.0](https://github.com/maoxian3824/hello-deb/releases/download/v1.0.0/hello-deb_1.0.0_amd64.deb) |
| arm64 (aarch64) | ARM 手机 / 开发板 / Termux proot | [v1.0.0-arm64](https://github.com/maoxian3824/hello-deb/releases/download/v1.0.0-arm64/hello-deb_1.0.0_arm64.deb) |

```bash
# amd64
curl -LO https://github.com/maoxian3824/hello-deb/releases/download/v1.0.0/hello-deb_1.0.0_amd64.deb

# arm64
curl -LO https://github.com/maoxian3824/hello-deb/releases/download/v1.0.0-arm64/hello-deb_1.0.0_arm64.deb
```

## 安装

先确认架构，再选对应包：

```bash
uname -m
# x86_64  -> 用 amd64 包
# aarch64 -> 用 arm64 包

sudo dpkg -i hello-deb_1.0.0_amd64.deb   # 或 arm64 包
hello-deb         # 输出: hello
```

## 卸载

```bash
sudo dpkg -r hello-deb
```

## 在 Termux 上使用

**Termux 原生环境装不了 deb 包**，因为 Termux 用的是 Android Bionic libc，不是 glibc，且安装前缀是 `/data/data/com.termux/files/usr`，三者互不兼容。有两种可行路径：

### 方式一：proot-distro（推荐，用 arm64 包）

```bash
pkg install proot-distro
proot-distro install debian
proot-distro login debian

# 进入 Debian 容器后
curl -LO https://github.com/maoxian3824/hello-deb/releases/download/v1.0.0-arm64/hello-deb_1.0.0_arm64.deb
dpkg -i hello-deb_1.0.0_arm64.deb
hello-deb   # 输出: hello
```

### 方式二：Termux 原生（不用 deb，直接放脚本）

本包的程序本体就是一个 POSIX shell 脚本，无任何编译依赖，所以可以直接放到 Termux 的 `$PREFIX/bin`：

```bash
mkdir -p $PREFIX/bin
printf '#!/bin/sh\necho "hello"\n' > $PREFIX/bin/hello-deb
chmod +x $PREFIX/bin/hello-deb
hello-deb   # 输出: hello
```

> 这种方式跳过了 dpkg，但功能完全等价，是 Termux 下的标准做法。

## 从源码重新构建

```bash
sh build.sh           # 构建 amd64 包（默认架构）
sh build.sh arm64     # 构建 arm64 包
```

产物分别为 `hello-deb_1.0.0_amd64.deb` 与 `hello-deb_1.0.0_arm64.deb`。

## 包结构

构建脚本会按架构生成临时目录 `hello-deb-<arch>/`（arm64 同理）再打包，结构如下：

```
hello-deb-amd64/
├── DEBIAN/
│   └── control      # 包元信息，声明 Architecture: amd64
└── usr/
    └── bin/
        └── hello-deb  # 实际安装到 /usr/bin/hello-deb
```

## 要点说明

- **架构命名**：Debian 体系里 x86_64 统一写作 `amd64`，写错会导致 64 位机器拒绝安装。
- **权限要求**：`DEBIAN/control` 必须 `644`，可执行程序必须 `755`。
- **打包命令**：使用 `dpkg-deb --build --root-owner-group` 保证包内文件属主为 `root/root`。
