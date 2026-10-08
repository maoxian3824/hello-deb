# Changelog

本项目的所有重要变更都记录在此文件。

格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-10-06

### 新增

- 提供 **amd64 (x64)** 与 **arm64 (aarch64)** 两种架构的 deb 包
- 安装后提供 `/usr/bin/hello-deb` 命令，执行输出 `hello`
- `build.sh` — 构建 amd64 包
- `build-arm64.sh` — 构建 arm64 包
- GitHub Actions 工作流，自动构建并验证两个架构的包：
  - 校验 `Architecture` 字段正确
  - 校验可执行文件权限为 `755`
  - 校验包内不含多余文件
  - 实际安装、运行、卸载的端到端验证
  - 生成 SHA256 校验和

### 说明

- 包内程序本体为 POSIX shell 脚本，无编译依赖
- `DEBIAN/control` 中 `Architecture: amd64` 对应 x86_64，
  这是 Debian 体系的标准命名
- 打包使用 `dpkg-deb --build --root-owner-group`，
  确保包内文件属主为 `root/root`

### 已知限制

- **Termux 原生环境无法安装本包**：Termux 使用 Android Bionic libc
  而非 glibc，且安装前缀为 `/data/data/com.termux/files/usr`，
  与 Debian 包体系不兼容。
  - 方案一：使用 `proot-distro` 安装 Debian 容器后安装 arm64 包
  - 方案二：直接把脚本放进 `$PREFIX/bin`（见 README）

[1.0.0]: https://github.com/maoxian3824/hello-deb/releases/tag/v1.0.0
