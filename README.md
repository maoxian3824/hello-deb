# hello-deb

一个最小的 Debian 打包示例，构建 **amd64 (x64)** 架构的 deb 包。

安装后提供 `/usr/bin/hello-deb` 命令，执行即输出 `hello`。

## 安装

```bash
# 确认架构
uname -m          # 应输出 x86_64

# 安装
sudo dpkg -i hello-deb_1.0.0_amd64.deb

# 运行
hello-deb         # 输出: hello
```

## 卸载

```bash
sudo dpkg -r hello-deb
```

## 从源码重新构建

```bash
sh build.sh
```

产物为 `hello-deb_1.0.0_amd64.deb`。

## 包结构

```
hello-deb/
├── DEBIAN/
│   ├── control      # 包元信息，声明 Architecture: amd64
│   └── postinst     # 安装后脚本
└── usr/
    └── bin/
        └── hello-deb  # 实际安装到 /usr/bin/hello-deb
```

## 要点说明

- **架构命名**：Debian 体系里 x86_64 统一写作 `amd64`，写错会导致 64 位机器拒绝安装。
- **权限要求**：`DEBIAN/control` 必须 `644`，可执行程序必须 `755`。
- **打包命令**：使用 `dpkg-deb --build --root-owner-group` 保证包内文件属主为 `root/root`。
