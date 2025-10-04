/**
 * RISC-V Assembly Blink Example
 * Educational example of GPIO control using RISC-V assembly
 */

.section .text
.global main
.type main, @function

# Hardware Register Addresses
.equ SIO_BASE, 0xd0000000   # Single-cycle IO base address

# SIO Register Offsets
.equ GPIO_OUT_SET, 0x18     # Set GPIO output bits
.equ GPIO_OUT_CLR, 0x20     # Clear GPIO output bits
.equ GPIO_OE_SET, 0x38      # Set GPIO output enable

# Configuration
.equ LED_PIN, 15            # GPIO pin for LED
.equ LED_DELAY_MS, 250      # Delay in milliseconds

.macro pause ms
    li   a0, \ms        # a0 = LED_DELAY_MS
    call sleep_ms
.endm

main:
    # Save return address and frame pointer
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)
    addi s0, sp, 16

    # Initialize GPIO using SDK function (gpio_init is not inline, so we can call it directly)
    li   a0, LED_PIN             # a0 = LED_PIN
    call gpio_init

    # Set GPIO direction to output: set bit 15 in SIO_GPIO_OE_SET
    li   s1, SIO_BASE            # t0 = SIO base address
    li   s2, 1 << LED_PIN        # t1 = 1 << 15 = bit mask for GPIO 15
    sw   s2, GPIO_OE_SET(s1)     # Enable output for GPIO 15

blink_loop:
    # Turn LED on: set bit 15 in SIO_GPIO_OUT_SET
    sw   s2, GPIO_OUT_SET(s1)    # Set GPIO 15 output high

    # Delay 250ms (sleep_ms(LED_DELAY_MS))
    pause LED_DELAY_MS

    # Turn LED off: clear bit 15 in SIO_GPIO_OUT_CLR
    sw   s2, GPIO_OUT_CLR(s1)    # Set GPIO 15 output low

    # Delay 250ms (sleep_ms(LED_DELAY_MS))
    pause LED_DELAY_MS

    # Loop forever
    j    blink_loop

.size main, .-main
