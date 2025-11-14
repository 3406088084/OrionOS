#!/bin/bash
echo "=== Building OrionOS Minimal ISO ==="
# 配置
CC="x86_64-elf-gcc"
CFLAGS="-ffreestanding -nostdlib -I kernel/include -O0"
# 清理并创建目录
echo "Preparing build environment..."
rm -rf build
mkdir -p build/kernel
mkdir -p build/iso_root/boot
mkdir -p build/iso_root/EFI/BOOT
# 检查工具链
if ! command -v x86_64-elf-gcc &> /dev/null; then
    echo "错误: 未找到 x86_64-elf-gcc 编译器"
    echo "请安装交叉编译器:"
    echo "  Ubuntu/Debian: sudo apt install gcc-x86-64-elf"
    echo "  Arch: sudo pacman -S x86_64-elf-gcc"
    exit 1
fi
if ! command -v xorriso &> /dev/null; then
    echo "错误: 未找到 xorriso"
    echo "请安装: sudo apt install xorriso"
    exit 1
fi
# 编译内核文件
echo "Compiling kernel..."
$CC $CFLAGS -c kernel/core/main.c -o build/kernel/main.o
$CC $CFLAGS -c kernel/drivers/video/vga.c -o build/kernel/vga.o
# 链接内核
echo "Linking kernel..."
x86_64-elf-ld -T linker.ld -o build/iso_root/boot/kernel.elf \
    build/kernel/main.o \
    build/kernel/vga.o
# 复制引导文件
echo "Setting up bootloader..."
cp limine/BOOTX64.EFI build/iso_root/EFI/BOOT/
cp limine/limine-bios.sys build/iso_root/
# 复制配置文件
cp boot/limine.cfg build/iso_root/boot/
# 创建ISO镜像
echo "Creating ISO image..."
xorriso -as mkisofs \
    -b limine/limine-bios-cd.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    --efi-boot limine/limine-uefi-cd.bin \
    -efi-boot-part --efi-boot-image \
    --protective-msdos-label \
    build/iso_root -o orionos-minimal.iso
echo ""
echo "✅ Build successful!"
echo " ISO created: orionos-minimal.iso"
echo ""
echo "To test:"
echo "  qemu-system-x86_64 -cdrom orionos-minimal.iso"
echo ""
echo "For debugging:"
echo "  qemu-system-x86_64 -cdrom orionos-minimal.iso -d guest_errors -no-shutdown -no-reboot"
