/**
 * RISC-V Assembly Blink Example
 * Usando API simplificada para estudantes
 */

.section .text
.global main
.type main, @function

# Definições para os estudantes
.equ LED_PIN, 15
.equ DIR_OUT, 1
.equ HIGH,    1
.equ LOW,     0
.equ DELAY_MS, 250

main:
    # Configura o pino: pico_gpio_init(pin=15, is_output=1)
    li   a0, LED_PIN
    li   a1, DIR_OUT
    call pico_gpio_init

blink_loop:
    # Liga LED: pico_gpio_write(pin=15, value=1)
    li   a0, LED_PIN
    li   a1, HIGH
    call pico_gpio_write

    li   a0, DELAY_MS
    call sleep_ms

    # Desliga LED: pico_gpio_write(pin=15, value=0)
    li   a0, LED_PIN
    li   a1, LOW
    call pico_gpio_write

    li   a0, DELAY_MS
    call sleep_ms

    j    blink_loop

.size main, .-main
