/**
 * RISC-V Assembly Blink Example
 * Using SDK header definitions for hardware access
 */

#include "hardware/regs/addressmap.h"
#include "hardware/regs/sio.h"

.section .text
.global main
.type main, @function

# Configuration
.equ LED_PIN, 15            # GPIO pin for LED
.equ LED_DELAY_MS, 250      # Delay in milliseconds

.macro pause ms
    li   a0, \ms
    call sleep_ms
.endm

main:
    # Save return address and registers
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)
    addi s0, sp, 16

    # 1. Initialize GPIO using SDK function (Symbol exists)
    li   a0, LED_PIN
    call gpio_init

    # 2. Set GPIO direction to output using SDK register definitions
    li   t0, SIO_BASE
    li   t1, (1 << LED_PIN)
    sw   t1, SIO_GPIO_OE_SET_OFFSET(t0)

blink_loop:
    # 3. Turn LED on (SIO_GPIO_OUT_SET)
    sw   t1, SIO_GPIO_OUT_SET_OFFSET(t0)

    pause LED_DELAY_MS

    # 4. Turn LED off (SIO_GPIO_OUT_CLR)
    sw   t1, SIO_GPIO_OUT_CLR_OFFSET(t0)

    pause LED_DELAY_MS

    j    blink_loop

.size main, .-main
