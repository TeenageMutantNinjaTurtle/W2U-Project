.thumb

.global FULL_COPY_ARM9_0x201DE26_LimiterPatches
.global FULL_COPY_ARM9_0x20204A4_LimiterPatches
.global FULL_COPY_ARM9_0x2033CFC_LimiterPatches
.global FULL_COPY_ARM9_0x200D6DC_LimiterPatches
.global FULL_COPY_ARM9_0x200CEA0_LimiterPatches


FULL_COPY_ARM9_0x200CEA0_LimiterPatches:
	.word 721 @ Makes all Dex Species Valid
	.size FULL_COPY_ARM9_0x200CEA0_LimiterPatches, .-FULL_COPY_ARM9_0x200CEA0_LimiterPatches

FULL_COPY_ARM9_0x200D6DC_LimiterPatches:
	.word 651 @ Idk what this is
	.size FULL_COPY_ARM9_0x200D6DC_LimiterPatches, .-FULL_COPY_ARM9_0x200D6DC_LimiterPatches

FULL_COPY_ARM9_0x201DE26_LimiterPatches:
	NOP @ Prevent Bad Eggs
	.size FULL_COPY_ARM9_0x201DE26_LimiterPatches, .-FULL_COPY_ARM9_0x201DE26_LimiterPatches

FULL_COPY_ARM9_0x20204A4_LimiterPatches:
	.word 0x33A @ Regional Dex Order
	.size FULL_COPY_ARM9_0x20204A4_LimiterPatches, .-FULL_COPY_ARM9_0x20204A4_LimiterPatches

FULL_COPY_ARM9_0x2033CFC_LimiterPatches:
	.word 0x1EA @ Manaphy Egg
	.word 0x2AB @ Bad Egg Species
	.word 0x3AB9 @ Form Palette Starting Index
	.word 0x3AB9 @ Form Palette Starting Index
	.word 0x3584 @ Egg Sprites ID
	.word 0x28B @ MAX_SLOTS
	.size FULL_COPY_ARM9_0x2033CFC_LimiterPatches, .-FULL_COPY_ARM9_0x2033CFC_LimiterPatches