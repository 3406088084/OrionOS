/* 内核链接脚本 */
ENTRY(kernel_main)
SECTIONS
{
    /* 内核加载到1MB地址（传统位置） */
    . = 0x100000;
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}
