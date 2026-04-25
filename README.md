# Blink - RISC-V Assembly LED Example

Educational example of GPIO control using RISC-V Assembly for Raspberry Pi Pico 2 W.

## Description

This project demonstrates how to control an LED from RISC-V Assembly, blinking it at 250ms intervals. Rather than accessing hardware registers directly, the assembly code calls a thin C API layer (`pico_gpio_api.c`) that wraps the Pico SDK. This two-layer design keeps the assembly code simple and focused on control flow and calling conventions.

## Hardware

- **Board:** Raspberry Pi Pico 2 W
- **LED Pin:** GPIO 15
- **Architecture:** RISC-V

## Features

- RISC-V Assembly entry point with clean, readable control flow
- Simplified C API layer callable directly from assembly
- GPIO abstraction through `pico_gpio_init` / `pico_gpio_write` / `pico_gpio_read`
- Configurable LED pin and delay via `.equ` constants
- RISC-V calling convention (ABI) in practice: argument registers and function calls
- Integration with Pico SDK timing (`sleep_ms`)
- Bare-metal programming educational example

## Code Structure

### Architecture

```
blink.S  ──calls──►  pico_gpio_api.c  ──calls──►  Pico SDK  ──►  Hardware
```

### `blink.S` — Assembly entry point

Defines configuration constants and implements `main`:

1. **GPIO Initialisation:** Calls `pico_gpio_init(LED_PIN, DIR_OUT)` to configure pin 15 as output
2. **Main Loop:**
   - Turn LED on via `pico_gpio_write(LED_PIN, HIGH)`
   - Wait 250 ms via `sleep_ms(DELAY_MS)`
   - Turn LED off via `pico_gpio_write(LED_PIN, LOW)`
   - Wait 250 ms via `sleep_ms(DELAY_MS)`
   - Repeat indefinitely

### `pico_gpio_api.c` — C GPIO wrapper

Provides three integer-based functions designed to be called from RISC-V Assembly following the standard calling convention (arguments in `a0`–`a7`, return value in `a0`):

| Function | Signature | Description |
|---|---|---|
| `pico_gpio_init` | `(int pin, int is_output)` | Initialises a pin and sets its direction |
| `pico_gpio_write` | `(int pin, int value)` | Drives a pin high (1) or low (0) |
| `pico_gpio_read` | `(int pin) → int` | Returns the current level of a pin (1 or 0) |

Each function wraps the corresponding Pico SDK call (`gpio_init`, `gpio_set_dir`, `gpio_put`, `gpio_get`) and translates between integer arguments and SDK types.

## Minimum Required Program

While `blink.S` contains ~45 lines to blink an LED, the **smallest valid program** that compiles and runs safely on the Pico 2 W is just three lines:

```asm
.global main
main:
    j main
```

Each line has a specific and mandatory role:

| Line | Role | What happens without it |
|------|------|------------------------|
| `.global main` | Exports the `main` symbol so the linker can find it. The Pico SDK startup code (part of `pico_stdlib`) runs first, initializes the hardware, and then calls `main` by name. | Linker error: `undefined reference to 'main'` |
| `main:` | Defines the label that marks the entry point of the program. | The `.global` directive has nothing to point to; the symbol does not exist. |
| `j main` | Infinite loop — jumps back to `main` unconditionally. Without it, the processor would continue executing whatever bytes follow in memory, causing unpredictable behaviour. | Undefined behaviour: the program falls off the end of the code. |

> **Why does the template have so many more lines?**
> The extra lines in `blink.S` implement real functionality: GPIO initialisation via the C API, a delay loop, and a blink loop. None of that is required just to *compile* — but all of it is required to *blink an LED correctly*.

## Requirements

- Raspberry Pi Pico SDK (version 2.2.0)
- RISC-V Toolchain (RISCV_ZCB_RPI_2_2_0_2)
- CMake (version 3.13 or higher)
- picotool (version 2.2.0-a4)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/afmiguel/risc-v-blink-asm.git
```

### 2. Open the project in VS Code

**Windows:**
```cmd
cd risc-v-blink-asm
code .
```

**macOS / Linux:**
```bash
cd risc-v-blink-asm
code .
```

> **Note:** The `code .` command opens VS Code in the current folder. If it is not recognized, open VS Code manually and use **File → Open Folder** to select the cloned folder.

## Building

The recommended way to build this project is through VS Code with the **Raspberry Pi Pico** extension, which automatically manages the SDK, toolchain, CMake and Ninja on all platforms.

### All platforms (VS Code — recommended)

1. Install [VS Code](https://code.visualstudio.com/) and the **Raspberry Pi Pico** extension
2. Open the project folder in VS Code
3. The extension detects `CMakeLists.txt` and configures everything automatically
4. Click **Compile Project** in the bottom status bar

### Windows (terminal)

Open the **Developer Command Prompt** or **PowerShell** with the Pico environment loaded:

```cmd
mkdir build
cd build
cmake -G "Ninja" ..
ninja
```

### macOS (terminal)

```bash
mkdir build
cd build
cmake ..
ninja
```

### Linux (terminal)

```bash
mkdir build
cd build
cmake ..
ninja
```

The build process will generate:
- `blink.elf` - Executable
- `blink.uf2` - File for uploading to Pico
- `blink.bin` - Binary image
- `blink.hex` - HEX file

## Uploading to Pico

1. Press and hold the BOOTSEL button on the Pico
2. Connect the Pico to your computer via USB
3. Release the BOOTSEL button (the Pico will appear as a USB drive)
4. Copy the `build/blink.uf2` file to the Pico drive
5. The Pico will automatically reboot and the LED will start blinking

## Configuration

Modify the following constants at the top of `blink.S`:

| Constant | Default | Description |
|---|---|---|
| `LED_PIN` | `15` | GPIO pin connected to the LED |
| `DELAY_MS` | `250` | Blink interval in milliseconds |

## Project Structure

```
risc-v-blink-asm/
├── blink.S               # RISC-V Assembly entry point (main)
├── pico_gpio_api.c       # C GPIO wrapper callable from assembly
├── CMakeLists.txt        # CMake build configuration
├── pico_sdk_import.cmake # Pico SDK import helper
├── build/                # Build output directory
└── .vscode/              # VS Code and Pico extension settings
```

## Additional Resources

- [pico_stdlib RISC-V ABI Reference](https://afmiguel.github.io/pico-riscv-asm-reference/) — How to call Pico SDK functions from RISC-V Assembly, with argument-to-register mapping and annotated examples for each function.

## Learning Objectives

This project is ideal for understanding:
- RISC-V Assembly programming and control flow
- RISC-V calling conventions (ABI): argument registers, return values, callee-saved registers
- Cross-language function calls between assembly and C
- GPIO control through a layered software abstraction
- Pico SDK project structure and CMake build system

## License

Open-source educational project.

## Author

Developed as an educational example for the Microprocessor Systems Design course.
