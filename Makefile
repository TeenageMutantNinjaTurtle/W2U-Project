project 		:= expansion
rom_code 		:= IRDO

# Directory configuration
build_dir 		:= build
code_build_dir  = $(build_dir)/code
asm_build 	    = $(code_build_dir)/asm
c_build 	    = $(code_build_dir)/c
src_dir         = src
asm_src_dir		:= $(src_dir)/asm
c_src_dir		:= $(src_dir)/c

game_base       := $(build_dir)/$(rom_code)
exefs 	        := $(game_base)/exefs
romfs 	        := $(game_base)/romfs

# Targets
asm_srcs  		:= $(wildcard $(asm_src_dir)/*.s)
asm_objs  		:= $(patsubst $(asm_src_dir)/%.s, $(asm_build)/%.d, $(asm_srcs)) 
c_srcs    		:= $(wildcard $(c_src_dir)/*.c)
c_objs    		:= $(patsubst $(c_src_dir)/%.c, $(c_build)/%.o, $(c_srcs)) 
objs      		:= $(asm_objs) $(c_objs)

# Tools
armips    		:= armips
blz 			:= tools/blz/blz
gcc 	  		:= arm-none-eabi-gcc
ndstool   		:= ndstool

.PHONY: clean all make_tools

all: $(project).nds 

$(project).nds: $(objs) $(game_base) make_narcs
	$(armips) $(src_dir)/Hooks.s
	$(armips) $(src_dir)/ARM9OVT.s
	$(ndstool) -c $@ -9 $(exefs)/ARM9.bin -7 $(exefs)/ARM7.bin -y9 $(exefs)/ARM9OVT.bin -y7 $(exefs)/ARM7OVT.bin -d $(romfs) -y $(exefs)/overlay -t $(exefs)/banner.bin -h $(exefs)/header.bin

$(game_base): make_tools
	mkdir -p $(exefs)
	mkdir -p $(romfs)
	$(ndstool) -x $(rom_code).nds -9 $(exefs)/ARM9.bin -7 $(exefs)/ARM7.bin -y9 $(exefs)/ARM9OVT.bin -y7 $(exefs)/ARM7OVT.bin -d $(romfs) -y $(exefs)/overlay -t $(exefs)/banner.bin -h $(exefs)/header.bin
	$(blz) -d $(exefs)/ARM9.bin
	$(blz) -d $(exefs)/overlay/*

$(asm_build)/%.d : $(asm_src_dir)/%.s
	$(AS) $(ASFLAGS) -c $< -o $@

$(c_build)/%.o : $(c_src_dir)/%.c
	mkdir -p  $(c_src_dir)
	@ echo -e "Compiling"
	$(gcc) $(CFLAGS) -c $< -o $@

make_tools:
	gcc -o tools/blz/blz tools/blz/blz.c
	make -C tools/knarc

make_narcs:
	python3 tools/NARCUpdater.py build/$(rom_code)

clean: 
	rm -rf $(project).nds
	rm -rf $(build_dir)