# Blink - RISC-V Assembly LED Example

Exemplo educacional de controle de GPIO usando Assembly RISC-V para Raspberry Pi Pico 2 W.

## Descrição

Este projeto demonstra como controlar um LED usando Assembly RISC-V puro, fazendo-o piscar com intervalos de 250ms. O código acessa diretamente os registradores de hardware do SIO (Single-cycle IO) para controlar o GPIO 15.

## Hardware

- **Placa:** Raspberry Pi Pico 2 W
- **Pino LED:** GPIO 15
- **Arquitetura:** RISC-V

## Características

- Código 100% em Assembly RISC-V
- Acesso direto aos registradores de hardware SIO
- Controle de GPIO para ligar/desligar LED
- Delay configurável (250ms por padrão)
- Exemplo educacional de programação bare-metal

## Estrutura do Código

O código em `blink.S` realiza:

1. **Inicialização do GPIO:** Configura o pino 15 como saída
2. **Loop Principal:**
   - Liga o LED (escreve em `SIO_GPIO_OUT_SET`)
   - Aguarda 250ms
   - Desliga o LED (escreve em `SIO_GPIO_OUT_CLR`)
   - Aguarda 250ms
   - Repete indefinidamente

### Registradores Utilizados

- `SIO_BASE`: `0xd0000000` - Endereço base do SIO
- `GPIO_OUT_SET`: Offset `0x18` - Define bits de saída
- `GPIO_OUT_CLR`: Offset `0x20` - Limpa bits de saída
- `GPIO_OE_SET`: Offset `0x38` - Habilita saída do GPIO

## Requisitos

- Raspberry Pi Pico SDK (versão 2.2.0)
- Toolchain RISC-V (RISCV_ZCB_RPI_2_2_0_2)
- CMake (versão 3.13 ou superior)
- picotool (versão 2.2.0-a4)

## Compilação

```bash
mkdir build
cd build
cmake ..
make
```

O processo de build gerará os arquivos:
- `blink.elf` - Executável
- `blink.uf2` - Arquivo para upload no Pico
- `blink.bin` - Imagem binária
- `blink.hex` - Arquivo HEX

## Upload para o Pico

1. Pressione e segure o botão BOOTSEL no Pico
2. Conecte o Pico ao computador via USB
3. Solte o botão BOOTSEL (o Pico aparecerá como drive USB)
4. Copie o arquivo `build/blink.uf2` para o drive do Pico
5. O Pico reiniciará automaticamente e o LED começará a piscar

## Configuração

Você pode modificar as seguintes constantes em `blink.S`:

- `LED_PIN`: Pino do GPIO para o LED (padrão: 15)
- `LED_DELAY_MS`: Intervalo de piscada em milissegundos (padrão: 250)

## Estrutura do Projeto

```
blink/
├── blink.S              # Código Assembly RISC-V
├── CMakeLists.txt       # Configuração do CMake
├── pico_sdk_import.cmake # Import do Pico SDK
├── build/               # Diretório de compilação
└── .vscode/             # Configurações do VS Code
```

## Aprendizado

Este projeto é ideal para entender:
- Programação em Assembly RISC-V
- Acesso direto a registradores de hardware
- Controle de GPIO em microcontroladores
- Estrutura de projetos com Pico SDK
- Convenções de chamada RISC-V (ABI)

## Licença

Projeto educacional de código aberto.

## Autor

Desenvolvido como exemplo educacional para o curso de Projeto de Sistemas Microprocessados.
