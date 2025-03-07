# 为GNU GCC macOS 嵌入式C/C++开发预编译的交叉编译工具链
本工具链由QiuChenly维护。

## 目标机器
任意基于AARCH64架构的Linux嵌入式设备或主机。
例如: 出厂预装20.04的算能BM系列盒子，瑞芯微系列的22.04Linux AI盒子。

## 编译机器
编译工具链的系统为macOS 10.15，ct-ng工具为1.24.0，开发机器为macOS 15构建。

### 主要用于

在macOS上配置cmake项目，并能够交叉编译出能够在目标Linux机器上运行的aarch64可执行文件，使用原生macOS CLion提供的本地高性能远程gdb Live Debug。

从此告别虚拟机开发嵌入式C/C++，不再痛苦折腾虚拟机环境。

之前用别人编译的交叉编译工具链 glibc只有2.17,太低了.
算能提供的opencv库最低要求2.31,编译都过不去.只能在虚拟机中安装macOS 10.15手动编译ct-ng工具进行重新编译。旧版本工具链需要用Clang 19.2.0的commandline tool进行编译才能编译过，macOS 15的版本Clang 22+太高了ct-ng根本编译不了。

## 工具链版本
GCC 10.5.0:
> Linux 内核 5.10.233<br>
> GLIBC 2.31 <br>
> GLIBCXX_3.4.28 <br>
> CXXABI_1.3.12 <br>

GCC 10.3.0:
> Linux 内核 5.11.6<br>
> GLIBC 2.31 <br>
> GLIBCXX_3.4.28 <br>
> CXXABI_1.3.12 <br>

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