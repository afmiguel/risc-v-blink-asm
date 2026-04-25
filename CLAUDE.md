# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Educational RISC-V Assembly example for the Raspberry Pi Pico 2 W (RP2350 chip), developed for a Microprocessor Systems Design course. The program blinks an LED on GPIO 15 at 250ms intervals.

## Build

**Recommended:** VS Code with the [Raspberry Pi Pico extension](https://marketplace.visualstudio.com/items?itemName=raspberry-pi.raspberry-pi-pico) — it auto-configures SDK, toolchain, CMake, and Ninja. Click **Compile Project** in the status bar.

**Terminal (macOS/Linux):**
```bash
mkdir build && cd build
cmake ..
ninja
```

**Terminal (Windows):** Use the Developer Command Prompt or PowerShell with the Pico environment loaded, then run the same `cmake`/`ninja` commands.

The SDK and toolchain are expected at `~/.pico-sdk/` (installed by the VS Code extension). Required versions: SDK 2.2.0, toolchain `RISCV_ZCB_RPI_2_2_0_2`, picotool 2.2.0-a4.

Build outputs land in `build/`: `blink.uf2` (flash to Pico), `blink.elf`, `blink.bin`, `blink.hex`.

**Flash to device:** Hold BOOTSEL, connect USB, release BOOTSEL, copy `build/blink.uf2` to the Pico mass-storage drive.

## Architecture

The project uses a two-layer design so students can write clean assembly without dealing with raw SDK calling conventions:

- **`blink.S`** — RISC-V assembly entry point (`main`). Uses the simplified C API below. Constants `LED_PIN` (15) and `DELAY_MS` (250) are defined as `.equ` at the top. No stack prologue is needed because `main` never returns.
- **`pico_gpio_api.c`** — Thin C wrapper around the Pico SDK. Exposes three functions callable from assembly with simple integer arguments:
  - `pico_gpio_init(pin, is_output)` — calls `gpio_init` + `gpio_set_dir`
  - `pico_gpio_write(pin, value)` — calls `gpio_put`
  - `pico_gpio_read(pin)` — calls `gpio_get`, returns 0 or 1
- **`CMakeLists.txt`** — Builds both files as a single `blink` target, links `pico_stdlib`. Board is `pico2_w`.

The backup `CMakeLists.txt.backup` is the original generated C-only template; ignore it.

## RISC-V / Pico ABI Notes

- Arguments pass in `a0`–`a7`; return value in `a0`.
- The SDK startup code (`pico_crt0`) runs before `main`; `main` must be exported with `.global main`.
- Because `main` never returns, no stack prologue (save `ra`, adjust `sp`) is required.
- Without a final `j blink_loop` (or equivalent infinite loop), the processor falls off the end of code — undefined behaviour on bare metal.

## Reference

[pico_stdlib RISC-V ABI Reference](https://afmiguel.github.io/pico-riscv-asm-reference/) — argument-to-register mapping and annotated examples for calling SDK functions from assembly.
