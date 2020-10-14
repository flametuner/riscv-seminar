static volatile char *uart;

/**
 *  Inicializa o UART da maquina `virt` localizada no endereço de memória 0x10000000
 * 
 */
int init()
{
    uart = (char *)(void *)0x10000000;
}

static int putchar(int ch)
{
    // Checkagem para registrador status (0x05) do UART (0x40 mascara para pegar bit certo)
    while ((uart[0x05]  & 0x40) == 0);
    // Seta o caractere no registrador do uart
    return uart[0x00] = ch & 0xff; //Mask para apenas os ultimos 2 bytes
}

/**
 * Loop para todas printar array de caracteres
 */
int print(const char *s)
{
    while (*s) putchar(*s++);
}

/**
 * Desliga a máquina com status code `status`
 */
void poweroff(int status)
{
    volatile int *test = (int *)(void *) 0x100000;
    *test = 0x5555;
    while (1) {
        asm volatile("");
    }
}

int main()
{
    init();
    print("Hello Seminar\n");
    poweroff(0);
}