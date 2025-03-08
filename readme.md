# 为GNU GCC macOS 嵌入式C/C++开发预编译的交叉编译工具链
本工具链由QiuChenly维护。

## 目标机器
任意基于aarch 64架构的Linux嵌入式设备或主机。

例如: 出厂预装20.04的算能BM系列盒子，瑞芯微系列的22.04Linux AI盒子。

## 主要应用

本交叉编译工具链均经过验证，用于在x86 macOS上交叉编译出aarch64 Linux嵌入式设备可执行二进制。

在macOS上配置cmake项目，并能够交叉编译出能够在目标aarch64 Linux机器上运行的aarch64可执行文件，使用原生macOS CLion提供的本地高性能远程gdb Live Debug。

从此告别虚拟机开发嵌入式C/C++，不再痛苦折腾虚拟机环境。

之前用别人编译的交叉编译工具链 glibc只有2.17,太低了.
算能提供的opencv库最低要求2.31,编译都过不去.只能在虚拟机中安装macOS 10.15手动编译ct-ng工具进行重新编译。旧版本工具链需要用Clang x86_64-apple-darwin19.6.0的commandline tool进行编译才能编译过，macOS 15的版本Clang 24.3.0+太高了ct-ng根本编译不了。

## 支持的macOS
基于X86_64架构的Intel Mac:

* macOS 10.15
* macOS 11+
* macOS 12+
* macOS 13+
* macOS 14+
* macOS 15+

## 工具链版本
### 内核版本说明
仅升级Linux内核为5.19.16, 如有极端特殊需要可下载5.10.233的旧内核工具链。<br>
实际使用推荐使用新版本内核5.19.16，其他工具链部分无差异.

> Linux 内核 5.10.233<br>
> 可选<br>
> Linux 内核 5.19.16<br>

### 如何选择适合自己的交叉编译工具链
1. 确定所需要远程调试的目标aarch64 Linux机器GLIBC/GLIBCXX版本。
2. 下载对应GLIBCXX版本ABI的工具链。
3. 工具链并不是越新越好, 如主播本人使用的macOS 15想交叉编译二进制到目标Ubuntu 20.04 , Glibc 2.31 GLIBCXX系统版本为3.4.28, 就只能使用 10.5版本工具链。
4. 但如果你觉得我命由我不由天，直接干tmd GCC 14.2最新版本编译,但是目标机器提示找不到GLIBCXX 3.4.32, 别慌, 强制升级系统的Libcxx.so版本就可以了。但为了原生程序稳定考虑，最好别这么干。主播一开始也是干tmd最新版14.2编译出GLIBCXX 3.4.32, 然后在20.04系统上起一个24.04 Ubuntu Docker容器也能运行，但是依赖的厂商库是旧版本，所以最好别这么干。

### GCC 10.5

Linux5.10.233_Glibc2.31_GCC10.5_ct-ng1.27.0.18_7458341.tar.gz<br>
Linux5.19.16_Glibc2.31_GCC10.5_ct-ng1.27.0.18_7458341.tar.gz

> GLIBC 2.31 <br>
> GLIBCXX_3.4.28 <br>
> CXXABI_1.3.12 <br>

### GCC 11.5

Linux5.10.233_Glibc2.31_GCC11.5_ct-ng1.27.0.18_7458341.tar.gz<br>
Linux5.19.16_Glibc2.31_GCC11.5_ct-ng1.27.0.18_7458341.tar.gz

> GLIBC 2.31 <br>
> GLIBCXX_3.4.29 <br>
> CXXABI_1.3.13 <br>

### GCC 12.4

Linux5.10.233_Glibc2.31_GCC12.4_ct-ng1.27.0.18_7458341.tar.gz<br>
Linux5.19.16_Glibc2.31_GCC12.4_ct-ng1.27.0.18_7458341.tar.gz

> GLIBC 2.31 <br>
> GLIBCXX_3.4.30 <br>
> CXXABI_1.3.13 <br>

### GCC 13.3

Linux5.10.233_Glibc2.31_GCC13.3_ct-ng1.27.0.18_7458341.tar.gz<br>
Linux5.19.16_Glibc2.31_GCC13.3_ct-ng1.27.0.18_7458341.tar.gz

> GLIBC 2.31 <br>
> GLIBCXX_3.4.32 <br>
> CXXABI_1.3.14 <br>

### GCC 14.2

Linux5.10.233_Glibc2.31_GCC14.2_ct-ng1.27.0.18_7458341.tar.gz<br>
Linux5.19.16_Glibc2.31_GCC14.2_ct-ng1.27.0.18_7458341.tar.gz

> GLIBC 2.31 <br>
> GLIBCXX_3.4.33 <br>
> CXXABI_1.3.15 <br>

## 工具链编译机器环境
编译工具链的系统为macOS 10.15，ct-ng工具为1.27.0.18_7458341。

## CLion中的注意事项
### 1. 解决无法调试下断点的问题
cmake中在project上面设置flag:
```cmake
# 解决无法调试下断点的问题
set(HAVE_FLAG_SEARCH_PATHS_FIRST 0)
project(YOURAPP)

# 建议设置C++ 17/20 太高的会有高级语法检查会导致报错
set(CMAKE_CXX_STANDARD 17)
# 设置 OSX SYSROOT
...
```

### 2. sysroot查找位置错误导致编译出错
macOS 上不设置这个根本没法编译 默认查找的是XCode的sysroot sdk 所以编译报错。
这个需要在project下面紧跟着设置OSX的sysroot，否则你会发现他默认查找的sysroot是xcode的, 编译会报错。
```cmake
set(CMAKE_OSX_SYSROOT "/Users/qiuchenly/Downloads/aarch64-10.5_QiuChenly_Linux5.10.233_GLibc2.31-linux-gnu/aarch64-10.5_QiuChenly_Linux6.13_GLibc2.31-linux-gnu/sysroot")
```

### 3. 为了不让gdb从远程重复拉取核心库 直接设置加载本地的sysroot 加快gdb解析速度：
修改文件：~/.gdbinit内容为:
```bash
set sysroot /Users/qiuchenly/Downloads/aarch64-10.5_QiuChenly_Linux5.10.233_GLibc2.31-linux-gnu/aarch64-10.5_QiuChenly_Linux6.13_GLibc2.31-linux-gnu/sysroot
```