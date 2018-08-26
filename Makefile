RISCV_PREFIX ?= riscv64-unknown-elf-

CC_32 = $(RISCV_PREFIX)gcc -march=rv32imac -mabi=ilp32
CC_64 = $(RISCV_PREFIX)gcc -march=rv64imac -mabi=lp64
AR    = $(RISCV_PREFIX)ar

CFLAGS=-mcmodel=medany -Os -g
LDFLAGS=-nostartfiles -nostdlib -static

PROBE_OBJ = probe.o
PROBE_RV32_OBJ = $(addprefix build/obj/rv32/,$(PROBE_OBJ))
PROBE_RV64_OBJ = $(addprefix build/obj/rv64/,$(PROBE_OBJ))

CORE_OBJS = entry.o trap.o csr.o snprintf.o printf.o
CORE_LIB = libcore.a
CORE_RV32_OBJ = $(addprefix build/obj/rv32/,$(CORE_OBJS))
CORE_RV64_OBJ = $(addprefix build/obj/rv64/,$(CORE_OBJS))

UART_SPIKE_HTIF_OBJS = uart_spike_htif.o
UART_SPIKE_HTIF_LIB = libuart_spike_htif.a
UART_SPIKE_HTIF_RV32_OBJ = $(addprefix build/obj/rv32/,$(UART_SPIKE_HTIF_OBJS))
UART_SPIKE_HTIF_RV64_OBJ = $(addprefix build/obj/rv64/,$(UART_SPIKE_HTIF_OBJS))

UART_QEMU_SIFIVE_OBJS = uart_qemu_sifive.o
UART_QEMU_SIFIVE_LIB = libuart_qemu_sifive.a
UART_QEMU_SIFIVE_RV32_OBJ = $(addprefix build/obj/rv32/,$(UART_QEMU_SIFIVE_OBJS))
UART_QEMU_SIFIVE_RV64_OBJ = $(addprefix build/obj/rv64/,$(UART_QEMU_SIFIVE_OBJS))

UART_COREIP_E2_ARTY_OBJS = uart_coreip_e2_arty.o
UART_COREIP_E2_ARTY_LIB = libuart_coreip_e2_arty.a
UART_COREIP_E2_ARTY_RV32_OBJ = $(addprefix build/obj/rv32/,$(UART_COREIP_E2_ARTY_OBJS))
UART_COREIP_E2_ARTY_RV64_OBJ = $(addprefix build/obj/rv64/,$(UART_COREIP_E2_ARTY_OBJS))

UART_VIRT_16550_OBJS = uart_virt_16550.o
UART_VIRT_16550_LIB = libuart_virt_16550.a
UART_VIRT_16550_RV32_OBJ = $(addprefix build/obj/rv32/,$(UART_VIRT_16550_OBJS))
UART_VIRT_16550_RV64_OBJ = $(addprefix build/obj/rv64/,$(UART_VIRT_16550_OBJS))

SPIKE_LD_SCRIPT=env/spike/default.lds
VIRT_LD_SCRIPT=env/virt/default.lds
QEMU_SIFIVE_U_LD_SCRIPT=env/qemu-sifive_u/default.lds
QEMU_SIFIVE_E_LD_SCRIPT=env/qemu-sifive_e/default.lds
COREIP_E2_ARTY_LD_SCRIPT=env/coreip-e2-arty/default.lds

ALL_PROGRAMS =	\
		build/bin/rv32/probe-spike \
		build/bin/rv64/probe-spike \
		build/bin/rv32/probe-virt \
		build/bin/rv64/probe-virt \
		build/bin/rv32/probe-qemu-sifive_e \
		build/bin/rv64/probe-qemu-sifive_e \
		build/bin/rv32/probe-qemu-sifive_u \
		build/bin/rv64/probe-qemu-sifive_u \
		build/bin/rv32/probe-coreip-e2-arty

all: programs

programs: $(ALL_PROGRAMS)

clean:
	rm -fr build

backup: clean
	tar czf ../$(shell basename $(shell pwd)).tar.gz .

build/obj/rv32/%.o: src/%.S
	@echo AS.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(CFLAGS) -c $^ -o $@

build/obj/rv64/%.o: src/%.S
	@echo AS.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(CFLAGS) -c $^ -o $@

build/obj/rv32/%.o: src/%.c
	@echo CC.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(CFLAGS) -c $^ -o $@

build/obj/rv64/%.o: src/%.c
	@echo CC.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(CFLAGS) -c $^ -o $@

build/lib/rv32/$(CORE_LIB): $(CORE_RV32_OBJ)
	@echo AR.32 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv64/$(CORE_LIB): $(CORE_RV64_OBJ)
	@echo AR.64 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv32/$(UART_SPIKE_HTIF_LIB): $(UART_SPIKE_HTIF_RV32_OBJ)
	@echo AR.32 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv64/$(UART_SPIKE_HTIF_LIB): $(UART_SPIKE_HTIF_RV64_OBJ)
	@echo AR.64 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv32/$(UART_QEMU_SIFIVE_LIB): $(UART_QEMU_SIFIVE_RV32_OBJ)
	@echo AR.32 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv32/$(UART_COREIP_E2_ARTY_LIB): $(UART_COREIP_E2_ARTY_RV32_OBJ)
	@echo AR.32 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv64/$(UART_QEMU_SIFIVE_LIB): $(UART_QEMU_SIFIVE_RV64_OBJ)
	@echo AR.64 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv32/$(UART_VIRT_16550_LIB): $(UART_VIRT_16550_RV32_OBJ)
	@echo AR.32 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/lib/rv64/$(UART_VIRT_16550_LIB): $(UART_VIRT_16550_RV64_OBJ)
	@echo AR.64 $@ ; mkdir -p $(@D) ; $(AR) cr $@ $^

build/bin/rv32/probe-spike: $(PROBE_RV32_OBJ) build/lib/rv32/$(CORE_LIB) build/lib/rv32/$(UART_SPIKE_HTIF_LIB)
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${SPIKE_LD_SCRIPT} $^ -o $@

build/bin/rv64/probe-spike: $(PROBE_RV64_OBJ) build/lib/rv64/$(CORE_LIB) build/lib/rv64/$(UART_SPIKE_HTIF_LIB)
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${SPIKE_LD_SCRIPT} $^ -o $@

build/bin/rv32/probe-virt: $(PROBE_RV32_OBJ) build/lib/rv32/$(CORE_LIB) build/lib/rv32/$(UART_VIRT_16550_LIB)
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${VIRT_LD_SCRIPT} $^ -o $@

build/bin/rv64/probe-virt: $(PROBE_RV64_OBJ) build/lib/rv64/$(CORE_LIB) build/lib/rv64/$(UART_VIRT_16550_LIB)
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${VIRT_LD_SCRIPT} $^ -o $@

build/bin/rv32/probe-qemu-sifive_e: $(PROBE_RV32_OBJ) build/lib/rv32/$(CORE_LIB) build/lib/rv32/$(UART_QEMU_SIFIVE_LIB)
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${QEMU_SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/rv64/probe-qemu-sifive_e: $(PROBE_RV64_OBJ) build/lib/rv64/$(CORE_LIB) build/lib/rv64/$(UART_QEMU_SIFIVE_LIB)
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${QEMU_SIFIVE_E_LD_SCRIPT} $^ -o $@

build/bin/rv32/probe-qemu-sifive_u: $(PROBE_RV32_OBJ) build/lib/rv32/$(CORE_LIB) build/lib/rv32/$(UART_QEMU_SIFIVE_LIB)
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${QEMU_SIFIVE_U_LD_SCRIPT} $^ -o $@

build/bin/rv64/probe-qemu-sifive_u: $(PROBE_RV64_OBJ) build/lib/rv64/$(CORE_LIB) build/lib/rv64/$(UART_QEMU_SIFIVE_LIB)
	@echo LD.64 $@ ; mkdir -p $(@D) ; $(CC_64) $(LDFLAGS) -T ${QEMU_SIFIVE_U_LD_SCRIPT} $^ -o $@

build/bin/rv32/probe-coreip-e2-arty: $(PROBE_RV32_OBJ) build/lib/rv32/$(CORE_LIB) build/lib/rv32/$(UART_COREIP_E2_ARTY_LIB)
	@echo LD.32 $@ ; mkdir -p $(@D) ; $(CC_32) $(LDFLAGS) -T ${COREIP_E2_ARTY_LD_SCRIPT} $^ -o $@
