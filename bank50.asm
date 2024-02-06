
    #ALIGN 16
zm_font:
    #INCGFX "font.png"
    .end:

    #ALIGN 16
blankTiles:
    ds $400, $7F
blankTileAttr:
    ds $400, $00

#INCLUDE "mon/stats.asm"

kidGfxInfo:
    db BANK(gfx_kid)
    dw gfx_kid
    db BANK(tilemap_kid)
    dw tilemap_kid
