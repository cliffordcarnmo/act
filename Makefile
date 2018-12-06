UNAME_S := $(shell uname -s)
ifneq (,$(findstring MINGW,$(UNAME_S)))
OS=WINDOWS
else ifeq ($(UNAME_S),Linux)
OS=LINUX
else ifeq ($(UNAME_S),Darwin)
OS=MACOS
endif

AMIGA_PATH=amiga
AMIGA_HD_PATH=hd
AMIGA_FLOPPY_PATH=floppy
AMIGA_KICKSTART_PATH=roms
AMIGA_KICKSTART_500=a500-1.3.rom
AMIGA_MODEL_500=a500
AMIGA_KICKSTART_600=a600-3.1.rom
AMIGA_MODEL_600=a600
AMIGA_KICKSTART_1200=a1200-3.1.rom
AMIGA_MODEL_1200=a1200
COMPILER=vc
ifeq ($(OS), WINDOWS)
COMPILER_OPTIONS=+kick13_win -v -speed -DAMIGA -DCPU=68000 -static
else
COMPILER_OPTIONS=+kick13 -v -speed -DAMIGA -DCPU=68000 -static
endif
SOURCE_PATH=src
TARGET_PATH=build
TARGET=out.exe
TARGET_ADF=out.adf

ifeq ($(OS),WINDOWS)
EMULATOR=$(shell echo $$APPDATA/../local/fs-uae)/fs-uae.exe
CRUNCHER=cruncher/Shrinkler_windows.exe
else ifeq ($(OS),LINUX)
EMULATOR=/usr/bin/fs-uae
CRUNCHER=cruncher/Shrinkler_linux
else ifeq ($(OS),MACOS)
EMULATOR=/Applications/FS-UAE.app/Contents/MacOS/fs-uae
CRUNCHER=cruncher/Shrinkler_macOS
endif

EMULATOR_OPTIONS=--floppy_drive_0=$(AMIGA_PATH)/$(AMIGA_FLOPPY_PATH)/$(TARGET_ADF) --window_width=640 --window_height=512 --floppy_drive_0_sounds=off --floppy_drive_1_sounds=off --initial_input_grab=off --console_debugger=1 --end_config=1
ifeq ($(OS),WINDOWS)
ADFTOOL=exe2adf/exe2adf_windows
else
ADFTOOL=amitools/xdftool
endif

all: clean compile pack copy adf run

build: clean compile pack copy adf

clean:
	rm -f $(TARGET_PATH)/$(TARGET)
	rm -f $(AMIGA_PATH)/$(AMIGA_HD_PATH)/$(TARGET)
	rm -f $(AMIGA_PATH)/$(AMIGA_FLOPPY_PATH)/$(TARGET_ADF)

compile:
	export VBCC=$(CURDIR); export PATH=$(shell pwd)/bin:$$PATH; $(COMPILER) $(COMPILER_OPTIONS) -o $(TARGET_PATH)/$(TARGET) $(SOURCE_PATH)/*.c

pack:
	$(CRUNCHER) $(TARGET_PATH)/$(TARGET) $(TARGET_PATH)/$(TARGET) 

copy:
	cp $(TARGET_PATH)/$(TARGET) $(AMIGA_PATH)/$(AMIGA_HD_PATH)/

adf:
ifeq (exe2adf,$(findstring exe2adf,$(ADFTOOL)))
	$(ADFTOOL) -i $(TARGET_PATH)/$(TARGET) -a $(AMIGA_PATH)/$(AMIGA_FLOPPY_PATH)/$(TARGET_ADF)
else
	$(ADFTOOL) $(AMIGA_PATH)/$(AMIGA_FLOPPY_PATH)/$(TARGET_ADF) create + format "out" ofs + boot install + write $(AMIGA_PATH)/$(AMIGA_HD_PATH)/$(TARGET) + makedir s + write $(AMIGA_PATH)/$(AMIGA_HD_PATH)/s/startup-sequence s 
endif

run: run500

run500:
	$(EMULATOR) --kickstart_file=$(AMIGA_PATH)/$(AMIGA_KICKSTART_PATH)/$(AMIGA_KICKSTART_500) --amiga_model=$(AMIGA_MODEL_500) $(EMULATOR_OPTIONS)

run600:
	$(EMULATOR) --kickstart_file=$(AMIGA_PATH)/$(AMIGA_KICKSTART_PATH)/$(AMIGA_KICKSTART_600) --amiga_model=$(AMIGA_MODEL_600) $(EMULATOR_OPTIONS)

run1200:
	$(EMULATOR) --kickstart_file=$(AMIGA_PATH)/$(AMIGA_KICKSTART_PATH)/$(AMIGA_KICKSTART_1200) --amiga_model=$(AMIGA_MODEL_1200) $(EMULATOR_OPTIONS)
