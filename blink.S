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
    li   t0, SIO_BASE            # t0 = SIO base address
    li   t1, 1                   # t1 = 1
    li   t2, LED_PIN             # t2 = 15
    sll  t1, t1, t2              # t1 = 1 << 15 = bit mask for GPIO 15
    sw   t1, GPIO_OE_SET(t0)     # Enable output for GPIO 15

blink_loop:
    # Turn LED on: set bit 15 in SIO_GPIO_OUT_SET
    li   t0, SIO_BASE            # t0 = SIO base address
    li   t1, 1                   # t1 = 1
    li   t2, LED_PIN             # t2 = 15
    sll  t1, t1, t2              # t1 = 1 << 15 = bit mask for GPIO 15
    sw   t1, GPIO_OUT_SET(t0)    # Set GPIO 15 output high

    # Delay 250ms (sleep_ms(LED_DELAY_MS))
    li   a0, LED_DELAY_MS        # a0 = LED_DELAY_MS
    call sleep_ms

    # Turn LED off: clear bit 15 in SIO_GPIO_OUT_CLR
    li   t0, SIO_BASE            # t0 = SIO base address
    li   t1, 1                   # t1 = 1
    li   t2, LED_PIN             # t2 = 15
    sll  t1, t1, t2              # t1 = 1 << 15 = bit mask for GPIO 15
    sw   t1, GPIO_OUT_CLR(t0)    # Set GPIO 15 output low

    # Delay 250ms (sleep_ms(LED_DELAY_MS))
    li   a0, LED_DELAY_MS        # a0 = LED_DELAY_MS
    call sleep_ms

    # Loop forever
    j    blink_loop

.size main, .-main
