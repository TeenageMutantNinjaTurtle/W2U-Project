.nds
.thumb

NUM_OF_MONS equ 721           // 89 02 00 00
NUM_REGIONAL_DEX_MONS equ 302 // 2d 01 00 00
REGIONAL_DEX_FILE equ 826

ALWAYS_HAVE_NATL_DEX equ 1

/*
when clicking on dex in the menu:
302, 301

sliding animation:
299, 139

blah blah unnecessary
habitat:
304, 139
*/

.open "build/IRDO/exefs/ARM9.bin", 0x02004000
// ARM9 Decompression
.org 0x02004FC4
.word 0

// based on what?
.org 0x0200C1C4
.word NUM_OF_MONS


// limiter on mon species being invalid
.org 0x0200CEA0
.word NUM_OF_MONS

// CountDexPkm
.org 0x0200D6DC
.word NUM_OF_MONS

// CountUnovaDexPokes
.org 0x0200DB00
.word NUM_OF_MONS


// CountRegionalPokesByIndices
.org 0x0200D728
.word NUM_OF_MONS


// CountSeenNationalDexPkm
.org 0x0200D884 
.word NUM_OF_MONS

// CountSeenRegionalDexPkm
.org 0x0200D8D0
.word NUM_OF_MONS


// CountPokesInNatDex
.org 0x0200DAA8
.word NUM_OF_MONS


// countUnovaSeenPokes
.org 0x0200DB58
.word NUM_OF_MONS

//.if ALWAYS_HAVE_NATL_DEX
//
//.org 0x0200D1AC
//    mov r0, #1
//    bx lr
//
//.endif

.org 0x020204A4
.word REGIONAL_DEX_FILE

.org 0x0201DE26
nop

.org 0x02033CFC
.word 0x1EA, 0x2AB, 0x3AB9, 0x3AB9, 0x3584, NUM_OF_MONS
.close


.open "build/IRDO/exefs/overlay/overlay_0299.bin", 0x0219FC00
// expand structure 
.org 0x0219FC12
mov r6, #0x1B
lsl r6, #8

.org 0x021A0520
.word NUM_OF_MONS

.org 0x021A0550
.word NUM_OF_MONS

// basically all the fucking names are baked into the structure because of course.  we move them to the end here

.org 0x021A0488
    bl getmonname

.org 0x021A04CA
    bl getmonname

.org 0x021A04F2
    bl getmonname

.org 0x021A053C
    bl readmonname

.org 0x021A0578
    bl readmon

// at the end of the file
.orga 0x2E40
getmonname:
    add r1, r5, r1
    push {r0}
    mov r0, #0xC7
    lsl r0, r0, #0x4
    add r1, r1, r0
    pop {r0}
    str r0, [r1, #0x4]
    bx lr
readmonname:
    add r0, r5, r0
    push {r1}
    mov r1, #0xC7
    lsl r1, r1, #0x4
    add r0, r1, r0
    pop {r1}
    ldr r0, [r0, #0x4]
    bx lr
readmon:
    mov r0, #0xC7
    lsl r0, r0, #0x4
    add r2, r0, r2
    ldr r2, [r2, #0x4]
    mov r0, r5
    bx lr
.close

// mon search lists down
.open "build/IRDO/exefs/overlay/overlay_0302.bin", 0x021ACF20
//.org 0x021ACF2C
//lsl r2, r6, #0x11

.org 0x021AE244
.word NUM_OF_MONS

// space limiter
.org 0x021AE310
.word 2 * NUM_OF_MONS

.org 0x021AE318 // what the fuck
.word NUM_OF_MONS

// a sort of species limiter
.org 0x021AE37C
.word 2 * NUM_OF_MONS // 12 05 00 00

.org 0x021AE384
.word NUM_OF_MONS

//.org 0x021AE3F8
//
//.word NUM_OF_MONS + 1 // file size 
.close

/*
grabbing regional dex indices is done 1x when clicking pokedex from the start menu

the first is from sub_21AE250 in overlay 302, specifically 021AE290

clicking on the sliding up anim, we get a return address of 021A0254 in overlay 299.  smallass function

second is 0x0200D896 in the arm9.  this is countSeenRegionalDexPokesByIndices, and is taken care of

last is 0x0200D6EE in the arm9.  this is countRegionalDexPokesByIndices, and is taken care of

switching over to national dex, it is called with an lr of 0x021A0254--fuck

clicking on it when in national dex mode, it then calls it once after slide up anim (none before slide up):
0x021A0254 again

switching over to regional dex, it appears that 0x021AE290 is responsible for making the lists

0x021A0255 is called then.  it dumps the list of regional dex mons to +C5C of the dex structure

followed by the counting functions again
*/