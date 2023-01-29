ASM=nasm

SRC_DIR=src
BUILD_DIR=build

#with this we can refeer to modules by name, instead of filename
.PHONY: all floppy_image kernel bootloader clean always


## FLOPPY IMAGE
# Create an empty floppy
# Initialize it with FAT12
# Copy the bootloader
# Copy the kernel
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880 
	mkfs.fat -F 12 $(BUILD_DIR)/main_floppy.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	


## BOOTLOADER
# Assemble the bootloader
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


## KERNEL
# Assemble the kernel
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin


## ALWAYS
# Make build dir
always:
	mkdir -p $(BUILD_DIR)

## CLEAN
# Clean build dir
clean:
	rm -rf $(BUILD_DIR)/*
