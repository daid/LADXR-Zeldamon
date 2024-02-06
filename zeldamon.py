from assembler import ASM, Assembler
import patches.aesthetics
import os
import roomEditor
import utils
import entityData


def buildLargeImageTiles(filename, *, offset=0, attr=0):
    all_tiles = patches.aesthetics.imageTo2bpp(os.path.dirname(__file__) + "/gfx/" + filename, tileheight=8, colormap=[0x800080, 0xFFFFFF, 0x808080, 0x000000])
    known_tiles = {}
    result_tiles = []
    tilemap = bytearray()
    for n in range(0, len(all_tiles) // 16):
        tile = bytes(all_tiles[n * 16:n*16+16])
        if tile not in known_tiles:
            known_tiles[tile] = (len(result_tiles), 0x08 | attr)
            result_tiles.append(tile)
        tilemap.append(known_tiles[tile][0] + offset)
        tilemap.append(known_tiles[tile][1])
    return tilemap, b''.join(result_tiles)


def addGraphics(asm):
    freebank = 0x7F
    asm.newSection(base_address=0x4000, bank=freebank)
    freebank -= 1
    gfx_data = {}
    for file in os.listdir(os.path.dirname(__file__) + "/gfx"):
        offset = 0
        attr = 0
        name_parts = os.path.splitext(file)[0].split("_")
        name = name_parts[0]
        for param in name_parts[1:]:
            if param == "back":
                name += "_back"
                offset = 0x40
            elif param.startswith("p"):
                attr |= int(param[1:])
        tilemap, tiledata = buildLargeImageTiles(file, offset=offset, attr=attr)
        # print(f"Tile count: {name}: {len(tiledata) // 16}")
        if asm.currentSectionSize() + len(tiledata) > 0x4000:
            asm.newSection(base_address=0x4000, bank=freebank)
            freebank -= 1
        asm.addLabel(f"gfx_{name}".upper())
        asm.insertData(tiledata)
        gfx_data[name] = tilemap
    asm.newSection(base_address=0x4000, bank=freebank)
    freebank -= 1
    for name, tilemap in gfx_data.items():
        if asm.currentSectionSize() + len(tilemap) > 0x4000:
            asm.newSection(base_address=0x4000, bank=freebank)
            freebank -= 1
        asm.addLabel(f"tilemap_{name}".upper())
        asm.insertData(tilemap)

def copySRAMLabels(asm):
    # Hack to allow our code to be copied to SRAM and still have labels.
    sram_labels = []
    for label, addr, bank in asm.getLabels():
        if label.startswith("SRAM_"):
            sram_labels.append((addr - asm.getLabel('SRAMCODE_START')[0] + 0xB100, label[5:]))
    asm.newSection(base_address=0xB100)
    sram_labels.sort()
    prev_addr = 0xB100
    for addr, label in sram_labels:
        size = addr - prev_addr
        prev_addr = addr
        asm.insertData(b'\x00' * size)
        if "." in label:
            asm.addLabel(label[label.find("."):])
        else:
            asm.addLabel(label)


def createSymbolFile(asm, input_filename, output_filename):
    if not os.path.isfile(input_filename):
        return
    f = open(output_filename, "wt")
    f.write(open(input_filename, "rt").read())
    for label, addr, bank in asm.getLabels():
        bank = bank if bank else 0
        f.write(f"{bank:02x}:{addr:02x} {label}\n")


def storeAssemblyInRom(asm, rom):
    # Store the result in the rom, and print sizes of stored results
    for section in sorted(asm.getSections(), key=lambda s: (s.bank or 0, s.base_address)):
        if section.bank is None:
            assert len(section.data) == 0 or section.base_address >= 0x8000
            if len(section.data) != 0:
                ram_size = 0x1000 - (section.base_address % 0x1000)
                print(f"RAM {section.base_address:04x}: {len(section.data):04x} ({int(len(section.data) / ram_size * 100)}%)")
            continue
        assert section.base_address + len(section.data) <= 0x8000, "Bank {section.bank:02x} overflowed: {section.base_address + len(section.data):04x}"

        print(f"Bank {section.bank:02x}:{len(section.data):04x} ({int(len(section.data)/0x4000*100)}%)")
        rom.banks[section.bank][section.base_address - 0x4000:section.base_address - 0x4000 + len(section.data)] = section.data


def dumpSymbolSizes(asm):
    labels_per_bank = {}
    for label, addr, bank in asm.getLabels():
        if bank not in labels_per_bank:
            labels_per_bank[bank] = []
        if "." not in label:
            labels_per_bank[bank].append((addr, label))
    for section in asm.getSections():
        labels_per_bank[section.bank].append((section.base_address + len(section.data), "__section_end"))
    for bank, labels in labels_per_bank.items():
        labels.sort()
        prev_addr, prev_label = None, None
        labelsizes = []
        for addr, label in labels:
            if prev_addr:
                labelsizes.append((addr - prev_addr, prev_label))
            prev_addr, prev_label = addr, label
        labelsizes.sort(reverse=True)
        for size, label in labelsizes:
            if bank:
                print(f"{bank:02x}: {label} {size}")


def prePatch(rom):
    # Double the amount of banks, so we have room to put all our extra code and graphics
    rom.banks += [bytearray(0x4000) for n in range(0x40)]
    rom.banks[0][0x148] = 0x06
    rom.banks[0][0x149] = 0x04

    rom.patch(0x01, 0x1F36, ASM("ld [hl], $00"), "", fill_nop=True)  # Don't disable SRAM ever
    rom.patch(0x01, 0x1F3A, ASM("ld [hl], $FF"), "", fill_nop=True)  # Don't disable SRAM ever

    asm = Assembler()
    asm.processFile(os.path.dirname(__file__), "const.asm")
    asm.processFile(os.path.dirname(__file__), "bank40.asm", base_address=0x4000, bank=0x40)
    asm.processFile(os.path.dirname(__file__), "bank41.asm", base_address=0x4000, bank=0x41)
    asm.processFile(os.path.dirname(__file__), "bank50.asm", base_address=0x4000, bank=0x50)
    asm.processFile(os.path.dirname(__file__), "mem.asm", base_address=0xAD00)

    addGraphics(asm)
    copySRAMLabels(asm)
    asm.link()
    storeAssemblyInRom(asm, rom)
    createSymbolFile(asm, "LADXR_DEFAULT_.sym", "LADXR_DEFAULT.sym")
    # dumpSymbolSizes(asm)

    # Patch over the creation of the debug save, this is done very early in initialization
    # Load our SRAM code.
    rom.patch(0x01, 0x06BC, 0x0793, ASM(f"""
#MACRO PUSHV
    ld   hl, \\1
    push hl
#END
    PUSHV done
    PUSHV $0100 ; Which bank to return to (us)
    PUSHV $0973 ; RestoreStackedBankAndReturn
    PUSHV {asm.getLabel("setupSRAMCode")[0]} ; Function to call
    PUSHV {asm.getLabel("setupSRAMCode")[1] << 8} ; Which bank to call
    PUSHV $0973 ; RestoreStackedBankAndReturn
    ret ; execute the ROP
done:
    ; After this our sram is setup, so we can execute things in it.
    ld   a, {asm.getLabel("checkSaveData")[1]}
    ld   hl, {asm.getLabel("checkSaveData")[0]}
    call $B100
    """, 0x46BC), fill_nop=True)

    # Patch the LCDC interrupt to jump to hram, so we can intercept this interrupt
    rom.patch(0x00, 0x0048, ASM("jp $0388"), ASM("jp $FF80"))

    def buildCallCode(label):
        addr, bank = asm.getLabel(label)
        return f"""
    push bc
    ld   a, {bank}
    ld   hl, {addr}
    call $B100
    pop  bc
"""

    # Replace the overworld map with a custom menu.
    rom.patch(0x01, 0x16F4, 0x1821, ASM(f"""
        {buildCallCode('pauseMenu')}
        ; Exit the "map"
        ld a, 6
        ld [$DB96], a
        ret
    """), fill_nop=True)

    # Change entity 4C into our "shopkeeper"
    rom.patch(0x03, 0x004C, "41", "94")
    rom.patch(0x03, 0x0147, "00", "98")
    rom.patch(0x20, 0x00e4, "000000", ASM(f"dw {asm.getLabel('zeldacenter')[0]}\ndb {asm.getLabel('zeldacenter')[1]}"))
    entityData.SPRITE_DATA[0x4C] = (2, 0x88)

    # Change that the telephone loads different music
    rom.patch(0x03, 0x097C, ASM("ld a, $33"), ASM("ld a, $48"))

    # Zelda-center rooms instead of phonebooth
    tiles = [
        37, 33, 33, 33, 33,153, 33, 33, 33, 38,
        35,206, 13, 13, 13,154, 13, 13, 13, 36,
        35,153,211,211,211,153,211,211,211, 36,
        35,154, 13, 15, 13,154, 13, 15, 13, 36,
        35,192, 13, 13, 13, 13, 13, 13, 13, 36,
        35,192, 13, 13, 13, 13, 13, 13, 13, 36,
        35, 13, 13, 13, 13, 13, 13, 13, 13, 36,
        39, 34, 34, 34,193,194, 34, 34, 34, 40,
    ]
    entities = [
        (3, 1, 0x4C),
        (7, 2, 0x80),
    ]
    for room_nr in [0x299, 0x29B, 0x29C, 0x29D, 0x2B4, 0x2CB, 0x2CC, 0x2E3]:
        re = roomEditor.RoomEditor(rom, room_nr)
        re.buildObjectList(tiles)
        re.entities = entities
        re.store(rom)

    # Inject code into the collision-with-link handler, this replaces
    # the "goomba jump" and "gel attaches to link" handling
    rom.patch(0x03, 0x2CF9, 0x2D4E, ASM(f"""
        ; The wCurrentBank isn't our current bank right now, but we do need to set and preserve it.
        ld   hl, $DBAF
        ld   a, [hl]
        ld   [hl], 3
        push af
        {buildCallCode("onEntityTouch")}
        pop  af
        ld   [$DBAF], a
        ; Check if the entity is destroyed, if so, skip damage handling.
        ldh  a, [$FFD7] ; hTMP0
        and  a, a
        ret  z
    """), fill_nop=True)

    # Patch into the ball throwing kids.
    rom.patch(0x06, 0x20A2, 0x20AA, ASM("jp $7F80"), fill_nop=True)
    rom.patch(0x06, 0x3F80, "00" * 0x20, ASM(f"""
        ld  hl, {asm.getLabel("sMonType")[0]}
        ld  e, 6
checkIfHaveMonsLoop:
        ld  a, [hl+]
        cp  $FF
        jp  nz, $6170 ; normal kids playing with balls.
        dec e
        jr  nz, checkIfHaveMonsLoop

        ldh a, [$FF99] ; linkY
        cp $80
        jp c, $6170 ; normal kids playing with balls.

        jp $60B2 ; bowwow kidnap event
    """), fill_nop=True)
    rom.texts[0x220] = utils.formatText("Hey buddy! It's serious! Yeah, really serious!! You should not go out there without some protection!")
    rom.patch(0x06, 0x213C, 0x216F, ASM(f"""
        ; Only run our special handler for one kid
        ldh  a, [$FFEB] ; hActiveEntityType 
        cp   $71 ; ENTITY_KID_71
        ret  nz
        
        ld   a, [$C19F] ; wDialogState
        and  a
        ret  nz
        
        {buildCallCode("giveInitialMon")}
    """), fill_nop=True)

    # Moldorm
    rom.patch(0x04, 0x1791, 0x17F2, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_04
        {buildCallCode("runBossBattle")}
        jp   $571D
    """), fill_nop=True)
    #Genie
    rom.patch(0x04, 0x0090, 0x00C7, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_04
        {buildCallCode("runBossBattle")}
        jp   $571D
    """), fill_nop=True)
    #Slime eye
    rom.patch(0x04, 0x0A2D, 0x0A67, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_04
        {buildCallCode("runBossBattle")}
        call GetEntityTransitionCountdown
        ld   [hl], 0
        jp   $571D
    """), fill_nop=True)
    #Angler fish
    rom.patch(0x05, 0x15D0, 0x1610, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_05
        {buildCallCode("runBossBattle")}
        call GetEntityTransitionCountdown
        ld   [hl], 0
        jp   $7585
    """), fill_nop=True)
    #Slime eel
    rom.patch(0x05, 0x2CE2, 0x2D03, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_05
        {buildCallCode("runBossBattle")}
        call GetEntityTransitionCountdown
        ld   [hl], 0
        jp   $7585
    """), fill_nop=True)
    #Evil eagle
    rom.patch(0x05, 0x1B03, 0x1B51, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ;ret  z
        call ReturnIfNonInteractive_05
        {buildCallCode("runBossBattle")}
        call GetEntityTransitionCountdown
        ld   [hl], 0
        jp   $7585
    """), fill_nop=True)
    rom.patch(0x05, 0x2258, 0x225A, "", fill_nop=True)
    #Hot head
    rom.patch(0x05, 0x231A, 0x2362, ASM(f"""
        ld   a, [wDidBossIntro]
        and  a, a 
        ret  z
        call ReturnIfNonInteractive_05
        {buildCallCode("runBossBattle")}
        call GetEntityTransitionCountdown
        ld   [hl], 0
        call $7585
        ld   hl, wEntitiesPosXTable                   ; $6361: $21 $00 $C2
        add  hl, de                                   ; $6364: $19
        ldh  a, [hLinkPositionX]                      ; $6365: $F0 $98
        ld   [hl], a                                  ; $6367: $77
        ld   hl, wEntitiesPosYTable                   ; $6368: $21 $10 $C2
        add  hl, de                                   ; $636B: $19
        ld   [hl], $70                                ; $636C: $36 $70
        ld   hl, wEntitiesPosZTable                   ; $636E: $21 $10 $C3
        add  hl, de                                   ; $6371: $19
        ld   [hl], $70                                ; $6372: $36 $70
        ret                                           ; $6374: $C9
    """), fill_nop=True)
    rom.patch(0x05, 0x2258, 0x225A, "", fill_nop=True)


def postPatch(rom):
    # Phonebooth icon replacement
    rom.banks[0x2C][0x1500:0x1510] = utils.createTileData("""........
11111112
   11211
    1121
    1122
   11122
11111122
11111112""", " 12.")
    rom.banks[0x2C][0x1460:0x1470] = utils.createTileData("""11122112
22222222
22222222
22222222
22211221
22111111
11111111
11111111""", " 12.")

    rom.banks[0x2C][0x1500:0x1510] = utils.createTileData("""........
11111112
   112..
    11. 
    11. 
   111. 
11..... 
11.     """, " 12.")
    rom.banks[0x2C][0x1460:0x1470] = utils.createTileData("""11.     
22..... 
222222.
222222. 
222112. 
221111..
11111111
11111111""", " 12.")

    if rom.banks[0][0x0091] == 0:
        # ingame time handler missing, add a ret so we do not crash trying to call it
        rom.patch(0, 0x0091, ASM("nop"), ASM("ret"))
