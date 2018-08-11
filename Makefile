#
# HUGO port on RS-97
#
# by pingflood; 2018
#

CHAINPREFIX := /opt/rs97-toolchain
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
STRIP = $(CROSS_COMPILE)strip

SYSROOT     := $(shell $(CC) --print-sysroot)

HUGO_VERSION=1.1.2

TARGET = ./dingux-hugo/dingux-hugo.dge

SDL_CONFIG = $(SYSROOT)/usr/bin/sdl-config


SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

OBJS = ./src/gp2x_psp.o \
  ./src/cpudingux.o \
  ./src/Hugo.o \
  ./src/psp_main.o \
  ./src/psp_sdl.o \
  ./src/psp_font.o \
  ./src/psp_kbd.o \
  ./src/psp_menu.o \
  ./src/psp_danzeff.o \
  ./src/psp_menu_set.o \
  ./src/psp_menu_help.o \
  ./src/psp_menu_cheat.o \
  ./src/psp_menu_list.o \
  ./src/psp_menu_kbd.o \
  ./src/psp_menu_joy.o \
  ./src/psp_editor.o \
  ./src/psp_fmgr.o \
  ./src/psp_audio.o \
  ./src/psp_joy.o \
  ./src/core/psp/osd_psp_cd.o \
  ./src/core/psp/osd_psp_mix.o \
  ./src/core/psp/osd_psp_gfx.o \
  ./src/core/psp/osd_psp_snd.o \
  ./src/core/psp/osd_psp_machine.o \
  ./src/core/psp/osd_psp_keyboard.o \
  ./src/core/cd.o \
  ./src/core/dis.o \
  ./src/core/edit_ram.o \
  ./src/core/followop.o \
  ./src/core/format.o \
  ./src/core/gfx.o \
  ./src/core/h6280.o \
  ./src/core/hard_pce.o \
  ./src/core/hugo.o \
  ./src/core/list_rom.o \
  ./src/core/lsmp3.o \
  ./src/core/mix.o \
  ./src/core/optable.o \
  ./src/core/pce.o \
  ./src/core/pcecd.o \
  ./src/core/sound.o \
  ./src/core/sprite.o \
  ./src/core/utils.o \
  ./src/core/hcd.o  \
  ./src/core/miniunz.o  \
  ./src/core/unzip.o  \
  ./src/core/bios.o ./src/core/cheat.o ./src/core/debug.o ./src/core/iniconfig.o ./src/core/bp.o

DEFAULT_CFLAGS = -I./src/ \
  -I./src/core -I./src/core/psp \
  -DDINGUX_MODE -DHUGO_VERSION=\"$(HUGO_VERSION)\" \
  -O3 -D_GNU_SOURCE=1 -D_REENTRANT -DIS_LITTLE_ENDIAN -DFINAL_RELEASE \
  -fsigned-char -ffast-math -fomit-frame-pointer \
  -fexpensive-optimizations -fno-strength-reduce 
  #-DDINGUX_MODE -DNO_STDIO_REDIRECT -DMPU_JZ4740 -DHUGO_VERSION=\"$(HUGO_VERSION)\" \
  # -funroll-loops  -finline-functions 
  # -DHUGO_OPTIM_IDLE
  # -ffast-math -fomit-frame-pointer -fno-strength-reduce 
  #  -funroll-loops  -finline-functions
  # -funroll-loops -ffast-math -fomit-frame-pointer -fno-strength-reduce -finline-functions \
  # -pipe -D_GNU_SOURCE=1 -D_REENTRANT -DIS_LITTLE_ENDIAN \
  -DUNIX -DBPP16 -DLSB_FIRST -DSOUND  -DNO_STDIO_REDIRECT  \
  -DDINGUX_MODE -O2

CFLAGS = $(DEFAULT_CFLAGS) $(SDL_CFLAGS) 
LDFLAGS = $(SDL_LIBS) -lSDL_image -lpng -lz

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJS) -o $(TARGET) && $(STRIP) $(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)

ctags: 
	ctags *[ch]

