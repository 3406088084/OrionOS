#include <kernel/types.h>

// 声明外部函数
void terminal_initialize(void);
void terminal_writestring(const char* data);

// 简单的字符串长度函数
size_t strlen(const char* str) {
    size_t len = 0;
    while (str[len]) len++;
    return len;
}

// 内核主函数
void kernel_main(void) {
    // 初始化终端显示
    terminal_initialize();
    
    // 显示启动信息
    terminal_writestring("=================================\n");
    terminal_writestring("        OrionOS Kernel\n");
    terminal_writestring("=================================\n");
    terminal_writestring("Status: Successfully loaded!\n");
    terminal_writestring("Architecture: x86_64\n");
    terminal_writestring("Bootloader: Limine\n");
    terminal_writestring("\n");
    terminal_writestring("System is ready for development.\n");
    terminal_writestring("\n> ");
    
    // 主循环
    while (1) {
        // 后续可以添加更多功能
        asm volatile ("hlt"); // 节能等待
    }
}