#!/bin/bash

# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# 定义 Pods 目录（默认 ./Pods，也可通过参数指定）
PODS_DIR="${1:-./Pods}"

# 查找 bitcode_strip 命令的路径
BITCODE_STRIP_PATH=""

# 首先尝试系统 PATH 中的命令
if command -v bitcode_strip &> /dev/null; then
    BITCODE_STRIP_PATH="bitcode_strip"
else
    # 尝试 Xcode 工具链中的路径
    XCODE_BITCODE_STRIP="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/bitcode_strip"
    if [ -f "$XCODE_BITCODE_STRIP" ]; then
        BITCODE_STRIP_PATH="$XCODE_BITCODE_STRIP"
    fi
fi

# 检查是否找到了 bitcode_strip
if [ -z "$BITCODE_STRIP_PATH" ]; then
    echo "错误: bitcode_strip 命令未找到，请确保 Xcode 命令行工具已安装"
    echo "尝试运行: xcode-select --install"
    exit 1
fi

echo "使用 bitcode_strip: $BITCODE_STRIP_PATH"

# 查找所有 Mach-O 二进制文件（.a 和 .framework 内的可执行文件）
find "$PODS_DIR" -type f \( -name "*.a" -o -path "*.framework/*" ! -name "*.h" ! -name "*.swift" ! -name "*.plist" \) | while read -r binary; do
    # 检查是否是 Mach-O 文件
    if file "$binary" | grep -q "Mach-O"; then
        echo "处理文件: $binary"
        
        # 创建临时文件
        TEMP_FILE="${binary}_temp"
        
        # 使用 bitcode_strip 移除 Bitcode
        if "$BITCODE_STRIP_PATH" -r "$binary" -o "$TEMP_FILE"; then
            # 替换原文件
            mv -f "$TEMP_FILE" "$binary"
            echo "✅ Bitcode 已移除"
        else
            echo "❌ 移除失败（可能已不含 Bitcode）"
            rm -f "$TEMP_FILE" 2>/dev/null
        fi
        
        echo "----------------------------------------"
    fi
done

echo "所有二进制文件的 Bitcode 移除完成！"