#
# Simple Makefile for a Prog8 program.
#

# Cross-platform commands
ifeq ($(OS),Windows_NT)
    CLEAN = del /Q build\* 
    CP = copy
    RM = del /Q
    MD = mkdir
    SEP = \\
else
    CLEAN = rm -f build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
    SEP = /
endif

# disk image settings
DISKTYPE=d64
DISKNAME=hello
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
EMU_CMD=x64sc
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK08=-8 $(DISK) -drive8type 1542
#EMU_DISK10=-fs10 build -device10 1 -iecdevice10 -virtualdev10
EMU_DISK10=
EMU_CART=
EMU_DISK=$(EMU_DISK08) $(EMU_DISK10)
EMU_DOS=
EMU_KERNAL=
EMU_REUSIZE=512
EMU_REU=-reu -reusize $(EMU_REUSIZE)
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_DOS) $(EMU_REU)

PCC=prog8c
PCCARGSC64=-srcdirs src -asmlist -target c64 -out build
PCCARGSX16=-srcdirs src -asmlist -target cx16 -out build

PROGS	= build/main-c64.prg build/main-cx16.prg
SRCS	= src/main.p8

all: build $(PROGS) disk

build:
	$(MD) build

build/main-c64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	mv build/main.prg build/main-c64.prg

build/main-cx16.prg: $(SRCS)
	$(PCC) $(PCCARGSX16) $<
	mv build/main.prg build/main-cx16.prg

clean:
	$(RM) build$(SEP)*

disk:	build/main-c64.prg
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK) 
	c1541 -attach $(DISK) -write build/main-c64.prg hello,p

emu:	emu-c64

emu-c64:	build/main-c64.prg
	$(EMU) -autostartprgmode 1 $<

emu-cx16:	build/main-cx16.prg
	x16emu -scale 2 -run -prg $<

#
# end-of-file
#
