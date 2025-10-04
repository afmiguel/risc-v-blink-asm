# Blink - RISC-V Assembly LED Example

Educational example of GPIO control using RISC-V Assembly for Raspberry Pi Pico 2 W.

## Description

This project demonstrates how to control an LED using pure RISC-V Assembly, blinking it at 250ms intervals. The code directly accesses SIO (Single-cycle IO) hardware registers to control GPIO 15.

## Hardware

- **Board:** Raspberry Pi Pico 2 W
- **LED Pin:** GPIO 15
- **Architecture:** RISC-V

## Features

- 100% RISC-V Assembly code with modern practices
- Direct SIO hardware register access
- GPIO control for LED on/off
- Configurable delay (250ms default)
- Proper stack frame management and ABI compliance
- Assembly macros for code reusability
- Integration with Pico SDK functions
- Bare-metal programming educational example

## Code Structure

The code in `blink.S` performs:

1. **Stack Frame Setup:** Saves return address (ra) and frame pointer (s0)
2. **GPIO Initialization:** Calls SDK `gpio_init()` function for pin 15
3. **GPIO Output Enable:** Sets bit 15 in `GPIO_OE_SET` register
4. **Main Loop:**
   - Turn LED on (writes to `SIO_GPIO_OUT_SET`)
   - Wait 250ms using `pause` macro
   - Turn LED off (writes to `SIO_GPIO_OUT_CLR`)
   - Wait 250ms using `pause` macro
   - Repeat indefinitely

### Assembly Features

- **Macros:** Custom `pause` macro for delay abstraction
- **Stack Frame:** Proper function prologue with ra/s0 preservation
- **Saved Registers:** Uses s1 (SIO_BASE) and s2 (LED bitmask) for loop efficiency
- **SDK Integration:** Calls `gpio_init()` and `sleep_ms()` SDK functions

### Hardware Registers

- `SIO_BASE`: `0xd0000000` - SIO base address
- `GPIO_OUT_SET`: Offset `0x18` - Set output bits
- `GPIO_OUT_CLR`: Offset `0x20` - Clear output bits
- `GPIO_OE_SET`: Offset `0x38` - Enable GPIO output

## Requirements

- Raspberry Pi Pico SDK (version 2.2.0)
- RISC-V Toolchain (RISCV_ZCB_RPI_2_2_0_2)
- CMake (version 3.13 or higher)
- picotool (version 2.2.0-a4)

## Building

```bash
mkdir build
cd build
cmake ..
make
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

You can modify the following constants in `blink.S`:

- `LED_PIN`: GPIO pin for the LED (default: 15)
- `LED_DELAY_MS`: Blink interval in milliseconds (default: 250)

## Project Structure

```
blink/
├── blink.S              # RISC-V Assembly code
├── CMakeLists.txt       # CMake configuration
├── pico_sdk_import.cmake # Pico SDK import
├── build/               # Build directory
└── .vscode/             # VS Code settings
```

## Learning Objectives

This project is ideal for understanding:
- RISC-V Assembly programming
- Direct hardware register access
- GPIO control in microcontrollers
- Pico SDK project structure
- RISC-V calling conventions (ABI)

## License

Open-source educational project.

## Author

Developed as an educational example for the Microprocessor Systems Design course.
