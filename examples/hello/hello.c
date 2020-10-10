static volatile char *uart;

int init()
{
	uart = (char *)(void *)0x10000000;
}

static int putchar(int ch)
{
    while (uart[0x00] < 0);
    return uart[0x00] = ch & 0xff;
}


int print(const char *s)
{
    while (*s) putchar(*s++);
}

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
	print("Hello World\n");
	poweroff(0);
}