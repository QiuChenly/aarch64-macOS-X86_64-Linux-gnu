base=$(pwd)

cd "$base"
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Found directory: $dir"

		rm -rf /Volumes/build/aarch64-macOS_QiuChenly-linux-gnu
        
        # 进入目录并执行操作
        cd "${base}/${dir}"
        echo "Current: $dir"
		ct-ng build
		cp .config /Volumes/build/aarch64-macOS_QiuChenly-linux-gnu/ct-ng.config

        # 切换到构建目录
        cd /Volumes/build
        
        # 定义压缩文件名
        tar_file="${dir%/}.tar.gz"
        
        # 使用 set -e 捕捉任何命令的错误并退出
        set +e  # 允许在此处继续，即使出现错误
        tar -czf "$tar_file" aarch64-macOS_QiuChenly-linux-gnu
        
        # 如果压缩失败，清理并退出
        if [ $? -ne 0 ]; then
            echo "Error occurred during compression. Deleting the incomplete tar file."
            rm -f "$tar_file"  # 删除失败的压缩文件
            cd "$base"  # 返回原始目录
            continue  # 跳过本次循环
        fi
        
        # 可选：删除构建目录
        rm -rf aarch64-macOS_QiuChenly-linux-gnu
        
        # 返回到 base 目录
        cd "$base"
    fi
done
