#MACRO MONSTER_STATS
    db \1, \2, \3, \4, \5, \6, \7, \8, \9
#END
#MACRO MONSTER_GFX
    #ASSERT \1 == __mon_idx
    __mon_idx := __mon_idx + 1

    ; Front
    db BANK(gfx_ ## \2)
    dw gfx_ ## \2
    db BANK(tilemap_ ## \2)
    dw tilemap_ ## \2
    ; Back
    db BANK(gfx_ ## \2 ## _back)
    dw gfx_ ## \2 ## _back
    db BANK(tilemap_ ## \2 ## _back)
    dw tilemap_ ## \2 ## _back
#END

__mon_idx := 0
; Table of base stats for each monster.
monsterBaseStats:
    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  40,  35,  70, 100, WATER, POISON, 190, 105 ; tentacool
    MONSTER_GFX MON_OCTOROCK, octorock
    db  MOVE_ACID, 0, 0, 0
    dw  INLINE(7, MOVE_SUPERSONIC, 13, MOVE_WRAP, 18, MOVE_POISON_STING, 22, MOVE_WATER_GUN, 27, MOVE_CONSTRICT, 33, MOVE_BARRIER, 40, MOVE_SCREECH, 48, MOVE_HYDRO_PUMP, 0)
    db  "Octorock"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  80,  35,  70,  35, FIGHTING, FIGHTING, 190, 74 ; mankey
    MONSTER_GFX MON_MOBLIN, moblin
    db  MOVE_SCRATCH, MOVE_LEER, 0, 0
    dw  INLINE(15, MOVE_KARATE_CHOP, 21, MOVE_FURY_SWIPES, 27, MOVE_FOCUS_ENERGY, 33, MOVE_SEISMIC_TOSS, 39, MOVE_THRASH, 0)
    db  "Moblin  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  30,  56,  35,  72,  25, NORMAL, NORMAL, 255, 57 ; rattata
    MONSTER_GFX MON_PIGWARRIOR, pigwarrior
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, 0, 0
    dw  INLINE(7, MOVE_QUICK_ATTACK, 14, MOVE_HYPER_FANG, 23, MOVE_FOCUS_ENERGY, 34, MOVE_SUPER_FANG, 0)
    db  "Pig War."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  80, 100,  20,  30, ROCK, GROUND, 255, 86 ; geodude
    MONSTER_GFX MON_DARKNUT, darknut
    db  MOVE_TACKLE, 0, 0, 0
    dw  INLINE(11, MOVE_DEFENSE_CURL, 16, MOVE_ROCK_THROW, 21, MOVE_SELFDESTRUCT, 26, MOVE_HARDEN, 31, MOVE_EARTHQUAKE, 36, MOVE_EXPLOSION, 0)
    db  "Darknut "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  70,  80,  50,  35,  35, FIGHTING, FIGHTING, 180, 88 ; machop
    MONSTER_GFX MON_SHROUDED_STALFOS, shroudedstalfos
    db  MOVE_KARATE_CHOP, 0, 0, 0
    dw  INLINE(20, MOVE_LOW_KICK, 25, MOVE_LEER, 32, MOVE_FOCUS_ENERGY, 39, MOVE_SEISMIC_TOSS, 46, MOVE_SUBMISSION, 0)
    db  "S.Stalfo"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  35,  30,  50,  20, BUG, POISON, 255, 52 ; weedle
    MONSTER_GFX MON_TEKTITE, tektite
    db  MOVE_POISON_STING, MOVE_STRING_SHOT, 0, 0
    dw  INLINE(0)
    db  "Tektite "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  45,  50,  55,  30,  75, GRASS, POISON, 255, 78 ; oddish
    MONSTER_GFX MON_LEEVER, leever
    db  MOVE_ABSORB, 0, 0, 0
    dw  INLINE(15, MOVE_POISONPOWDER, 17, MOVE_STUN_SPORE, 19, MOVE_SLEEP_POWDER, 24, MOVE_ACID, 33, MOVE_PETAL_DANCE, 46, MOVE_SOLARBEAM, 0)
    db  "Leever  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  30,  65, 100,  40,  45, WATER, WATER, 190, 97 ; shellder
    MONSTER_GFX MON_ARMOS_STATUE, armosstatue
    db  MOVE_TACKLE, MOVE_WITHDRAW, 0, 0
    dw  INLINE(18, MOVE_SUPERSONIC, 23, MOVE_CLAMP, 30, MOVE_AURORA_BEAM, 39, MOVE_LEER, 50, MOVE_ICE_BEAM, 0)
    db  "Armos S."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  30,  35,  30,  80, 100, GHOST, POISON, 190, 95 ; gastly
    MONSTER_GFX MON_GHINI, ghini
    db  MOVE_LICK, MOVE_CONFUSE_RAY, MOVE_NIGHT_SHADE, 0
    dw  INLINE(27, MOVE_HYPNOSIS, 35, MOVE_DREAM_EATER, 0)
    db  "Ghini   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  45,  50,  45,  95, 115, GHOST, POISON, 90, 126 ; haunter
    MONSTER_GFX MON_GIANT_GHINI, giantghini
    db  MOVE_LICK, MOVE_CONFUSE_RAY, MOVE_NIGHT_SHADE, 0
    dw  INLINE(29, MOVE_HYPNOSIS, 38, MOVE_DREAM_EATER, 0)
    db  "G.Ghini "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  41,  64,  45,  50,  50, DRAGON, DRAGON, 45, 67 ; dratini
    MONSTER_GFX MON_MOBLIN_SWORD, moblinsword
    db  MOVE_WRAP, MOVE_LEER, 0, 0
    dw  INLINE(10, MOVE_THUNDER_WAVE, 20, MOVE_AGILITY, 30, MOVE_SLAM, 40, MOVE_DRAGON_RAGE, 50, MOVE_HYPER_BEAM, 0)
    db  "Moblin-S"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  50,  95,  35,  40, GROUND, GROUND, 190, 87 ; cubone
    MONSTER_GFX MON_PIGWARRIOR_SWORD, pigwarriorsword
    db  MOVE_BONE_CLUB, MOVE_GROWL, 0, 0
    dw  INLINE(25, MOVE_LEER, 31, MOVE_FOCUS_ENERGY, 38, MOVE_THRASH, 43, MOVE_BONEMERANG, 46, MOVE_RAGE, 0)
    db  "Pig-S   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  35,  85,  45,  75,  35, NORMAL, NORMAL, 190, 95 ; doduo
    MONSTER_GFX MON_DARKNUT_SWORD, darknutsword
    db  MOVE_TACKLE, 0, 0, 0
    dw  INLINE(20, MOVE_GROWL, 24, MOVE_FURY_ATTACK, 30, MOVE_DRILL_PECK, 36, MOVE_RAGE, 40, MOVE_TRI_ATTACK, 44, MOVE_AGILITY, 0)
    db  "DarknutS"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  30,  40,  70,  60,  70, WATER, WATER, 225, 83 ; horsea
    MONSTER_GFX MON_SHROUDED_STALFOS_SWORD, shroudedstalfossword
    db  MOVE_BUBBLE, 0, 0, 0
    dw  INLINE(19, MOVE_SMOKESCREEN, 24, MOVE_LEER, 30, MOVE_WATER_GUN, 37, MOVE_AGILITY, 45, MOVE_HYDRO_PUMP, 0)
    db  "SSStalfo"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  30,  45,  55,  85,  70, WATER, WATER, 225, 106 ; staryu
    MONSTER_GFX MON_ANTI_FAIRY, antifairy
    db  MOVE_TACKLE, 0, 0, 0
    dw  INLINE(17, MOVE_WATER_GUN, 22, MOVE_HARDEN, 27, MOVE_RECOVER, 32, MOVE_SWIFT, 37, MOVE_MINIMIZE, 42, MOVE_LIGHT_SCREEN, 47, MOVE_HYDRO_PUMP, 0)
    db  "A-Fairy "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  30,  50, 100,  55, ELECTRIC, ELECTRIC, 190, 103 ; voltorb
    MONSTER_GFX MON_SPARK, spark
    db  MOVE_TACKLE, MOVE_SCREECH, 0, 0
    dw  INLINE(17, MOVE_SONICBOOM, 22, MOVE_SELFDESTRUCT, 29, MOVE_LIGHT_SCREEN, 36, MOVE_SWIFT, 43, MOVE_EXPLOSION, 0)
    db  "Spark   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  70,  45,  48,  35,  60, NORMAL, NORMAL,  150, 68 ; clefairy
    MONSTER_GFX MON_POLS_VOICE, polsvoice
    db  MOVE_POUND, MOVE_GROWL, 0, 0
    dw  INLINE(13, MOVE_SING, 18, MOVE_DOUBLESLAP, 24, MOVE_MINIMIZE, 31, MOVE_METRONOME, 39, MOVE_DEFENSE_CURL, 48, MOVE_LIGHT_SCREEN, 0)
    db  "P.Voice "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  45,  35,  55,  40, POISON, FLYING,  255, 54 ; zubat
    MONSTER_GFX MON_KEESE, keese
    db  MOVE_LEECH_LIFE, 0, 0, 0
    dw  INLINE(10, MOVE_SUPERSONIC, 15, MOVE_BITE, 21, MOVE_CONFUSE_RAY, 28, MOVE_WING_ATTACK, 36, MOVE_HAZE, 0)
    db  "Keese   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  75,  85,  40,  30, GROUND, GROUND,  255, 93 ; sandshrew
    MONSTER_GFX MON_STALFOS, stalfos
    db  MOVE_SCRATCH, 0, 0, 0
    dw  INLINE(10, MOVE_SAND_ATTACK, 17, MOVE_SLASH, 24, MOVE_POISON_STING, 31, MOVE_SWIFT, 38, MOVE_FURY_SWIPES, 0)
    db  "Stalfos "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  80,  80,  50,  25,  40, POISON, POISON,  190, 90 ; grimer
    MONSTER_GFX MON_GREEN_ZOL, zolgreen
    db  MOVE_POUND, MOVE_DISABLE, 0, 0
    dw  INLINE(30, MOVE_POISON_GAS, 33, MOVE_MINIMIZE, 37, MOVE_SLUDGE, 42, MOVE_HARDEN, 48, MOVE_SCREECH, 55, MOVE_ACID_ARMOR, 0)
    db  "Gr.Zol  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  80,  80,  50,  25,  40, POISON, POISON,  190, 90 ; grimer
    MONSTER_GFX MON_RED_ZOL, zolred
    db  MOVE_POUND, MOVE_DISABLE, 0, 0
    dw  INLINE(30, MOVE_POISON_GAS, 33, MOVE_MINIMIZE, 37, MOVE_SLUDGE, 42, MOVE_HARDEN, 48, MOVE_SCREECH, 55, MOVE_ACID_ARMOR, 0)
    db  "Rd.Zol  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  45,  30,  35,  45,  20,  BUG,  BUG, 255, 53 ; caterpie
    MONSTER_GFX MON_GEL, gel
    db  MOVE_TACKLE, MOVE_STRING_SHOT, 0, 0
    dw  INLINE(0)
    db  "Gel     "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  55,  95, 115,  35,  45, ROCK, GROUND,  120, 134 ; graveler
    MONSTER_GFX MON_GIBDO, gibdo
    db  MOVE_TACKLE, MOVE_DEFENSE_CURL, 0, 0
    dw  INLINE(11, MOVE_DEFENSE_CURL, 16, MOVE_ROCK_THROW, 21, MOVE_SELFDESTRUCT, 29, MOVE_HARDEN, 36, MOVE_EARTHQUAKE, 43, MOVE_EXPLOSION, 0)
    db  "Gibdo   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  45,  25,  50,  35,  25, BUG, POISON,  120, 71 ; kakuna
    MONSTER_GFX MON_HARDHAT_BEETLE, hardhat
    db  MOVE_HARDEN, 0, 0, 0
    dw  INLINE(0)
    db  "H.Beetle"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  65,  50,  35,  95,  95, ICE, PSYCHIC, 45, 137 ; jynx
    MONSTER_GFX MON_WIZROBE, wizrobe
    db  MOVE_POUND, MOVE_LOVELY_KISS, 0, 0
    dw  INLINE(18, MOVE_LICK, 23, MOVE_DOUBLESLAP, 31, MOVE_ICE_PUNCH, 39, MOVE_BODY_SLAM, 47, MOVE_THRASH, 58, MOVE_BLIZZARD, 0)
    db  "Wizrobe "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  35,  60,  44,  55,  40, POISON, POISON, 255, 62 ; ekans
    MONSTER_GFX MON_LIKE_LIKE, likelike
    db  MOVE_WRAP, MOVE_LEER, 0, 0
    dw  INLINE(10, MOVE_POISON_STING, 17, MOVE_BITE, 24, MOVE_GLARE, 31, MOVE_SCREECH, 38, MOVE_ACID, 0)
    db  "LikeLike"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  80,  85,  95,  25,  30, GROUND, ROCK, 120, 135 ; rhyhorn
    MONSTER_GFX MON_IRON_MASK, ironmask
    db  MOVE_HORN_ATTACK, 0, 0, 0
    dw  INLINE(30, MOVE_STOMP, 35, MOVE_TAIL_WHIP, 40, MOVE_FURY_ATTACK, 45, MOVE_HORN_DRILL, 50, MOVE_LEER, 55, MOVE_TAKE_DOWN, 0)
    db  "IronMask"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  52,  48,  55,  50, WATER, WATER, 190, 80 ; psyduck
    MONSTER_GFX MON_MIMIC, mimic
    db  MOVE_SCRATCH, 0, 0, 0
    dw  INLINE(28, MOVE_TAIL_WHIP, 31, MOVE_DISABLE, 36, MOVE_CONFUSION, 43, MOVE_FURY_SWIPES, 52, MOVE_HYDRO_PUMP, 0)
    db  "Mimic   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  35,  45, 160,  70,  30, ROCK, GROUND, 45, 108 ; onix
    MONSTER_GFX MON_MINI_MOLDORM, minimoldorm
    db  MOVE_TACKLE, MOVE_SCREECH, 0, 0
    dw  INLINE(15, MOVE_BIND, 19, MOVE_ROCK_THROW, 25, MOVE_RAGE, 33, MOVE_SLAM, 43, MOVE_HARDEN, 0)
    db  "M.Moldor"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  45,  49,  49,  45,  65, GRASS, POISON, 45, 64 ; bulbasaur
    MONSTER_GFX MON_SPIKED_BEETLE, spikedbeetle
    db  MOVE_TACKLE, MOVE_GROWL, 0, 0
    dw  INLINE(7, MOVE_LEECH_SEED, 13, MOVE_VINE_WHIP, 20, MOVE_POISONPOWDER, 27, MOVE_RAZOR_LEAF, 34, MOVE_GROWTH, 41, MOVE_SLEEP_POWDER, 48, MOVE_SOLARBEAM, 0)
    db  "S.Beetle"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  60,  65,  60, 110, 130, GHOST, POISON, 45, 190 ; gengar
    MONSTER_GFX MON_BOO_BUDDY, boobuddy
    db  MOVE_LICK, MOVE_CONFUSE_RAY, MOVE_NIGHT_SHADE, 0
    dw  INLINE(29, MOVE_HYPNOSIS, 38, MOVE_DREAM_EATER, 0)
    db  "Boo     "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  65, 105,  60,  95,  60, FIGHTING, FIGHTING, 75, 149 ; primeape
    MONSTER_GFX MON_BALL_AND_CHAIN, ballandchain
    db  MOVE_SCRATCH, MOVE_LEER, MOVE_KARATE_CHOP, MOVE_FURY_SWIPES
    dw  INLINE(15, MOVE_KARATE_CHOP, 21, MOVE_FURY_SWIPES, 27, MOVE_FOCUS_ENERGY, 37, MOVE_SEISMIC_TOSS, 46, MOVE_THRASH, 0)
    db  "B.Chain "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  25,  35,  70,  45,  95, ELECTRIC, ELECTRIC, 190, 89 ; magnemite
    MONSTER_GFX MON_BOMBITE, bombite
    db  MOVE_TACKLE, 0, 0, 0
    dw  INLINE(21, MOVE_SONICBOOM, 25, MOVE_THUNDERSHOCK, 29, MOVE_SUPERSONIC, 35, MOVE_THUNDER_WAVE, 41, MOVE_SWIFT, 47, MOVE_SCREECH, 0)
    db  "Bombite "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  60,  30,  70,  31, NORMAL, FLYING, 255, 58 ; spearow
    MONSTER_GFX MON_PAIRODD, pairodd
    db  MOVE_PECK, MOVE_GROWL, 0, 0
    dw  INLINE(9, MOVE_LEER, 15, MOVE_FURY_ATTACK, 22, MOVE_MIRROR_MOVE, 29, MOVE_DRILL_PECK, 36, MOVE_AGILITY, 0)
    db  "Pairodd "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  50,  40,  90,  40, WATER, WATER, 255, 77 ; poliwag
    MONSTER_GFX MON_MASKED_MIMIC, maskedmimic
    db  MOVE_BUBBLE, 0, 0, 0
    dw  INLINE(16, MOVE_HYPNOSIS, 19, MOVE_WATER_GUN, 25, MOVE_DOUBLESLAP, 31, MOVE_BODY_SLAM, 38, MOVE_AMNESIA, 45, MOVE_HYDRO_PUMP, 0)
    db  "M.Mimic "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  52,  65,  55,  60,  58, NORMAL, FLYING, 255, 77 ; farfetchd
    MONSTER_GFX MON_CROW, crow
    db  MOVE_PECK, MOVE_SAND_ATTACK, 0, 0
    dw  INLINE(7, MOVE_LEER, 15, MOVE_FURY_ATTACK, 23, MOVE_SWORDS_DANCE, 31, MOVE_AGILITY, 39, MOVE_SLASH, 0)
    db  "Crow    "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  80, 105,  65,  70, 100, GRASS, POISON, 45, 191 ; victreebel
    MONSTER_GFX MON_GIANT_GOPONGA_FLOWER, giantgoponga
    db  MOVE_SLEEP_POWDER, MOVE_STUN_SPORE, MOVE_ACID, MOVE_RAZOR_LEAF
    dw  INLINE(13, MOVE_WRAP, 15, MOVE_POISONPOWDER, 18, MOVE_SLEEP_POWDER, 0)
    db  "GGoponga"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  75,  35,  40,  70, GRASS, POISON, 255, 84 ; bellsprout
    MONSTER_GFX MON_GOPONGA_FLOWER, goponga
    db  MOVE_VINE_WHIP, MOVE_GROWTH, 0, 0
    dw  INLINE(13, MOVE_WRAP, 15, MOVE_POISONPOWDER, 18, MOVE_SLEEP_POWDER, 21, MOVE_STUN_SPORE, 26, MOVE_ACID, 33, MOVE_RAZOR_LEAF, 42, MOVE_SLAM, 0)
    db  "Goponga "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  40,  45,  35,  90,  40, NORMAL, NORMAL, 255, 69 ; meowth
    MONSTER_GFX MON_THREE_OF_A_KIND, threeofakind
    db  MOVE_SCRATCH, MOVE_GROWL, 0, 0
    dw  INLINE(12, MOVE_BITE, 17, MOVE_PAY_DAY, 24, MOVE_SCREECH, 33, MOVE_FURY_SWIPES, 44, MOVE_SLASH, 0)
    db  "3ofaKind"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  90,  85,  95,  70,  70, WATER, FIGHTING, 45, 185 ; poliwrath
    MONSTER_GFX MON_ANTI_KIRBY, antikirby
    db  MOVE_HYPNOSIS, MOVE_WATER_GUN, MOVE_DOUBLESLAP, MOVE_BODY_SLAM
    dw  INLINE(16, MOVE_HYPNOSIS, 19, MOVE_WATER_GUN, 0)
    db  "A.Kirby "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  60,  95,  70, 120, ELECTRIC, ELECTRIC, 60, 161 ; magneton
    MONSTER_GFX MON_MAD_BOMBER, madbomber
    db  MOVE_TACKLE, MOVE_SONICBOOM, MOVE_THUNDERSHOCK, 0
    dw  INLINE(21, MOVE_SONICBOOM, 25, MOVE_THUNDERSHOCK, 29, MOVE_SUPERSONIC, 38, MOVE_THUNDER_WAVE, 46, MOVE_SWIFT, 54, MOVE_SCREECH, 0)
    db  "M.Bomber"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  50,  85,  55,  90,  65, FIRE, FIRE, 190, 152 ; magneton
    MONSTER_GFX MON_HORSE_PIECE, horsepiece
    db  MOVE_EMBER, 0, 0, 0
    dw  INLINE(21, MOVE_SONICBOOM, 25, MOVE_THUNDERSHOCK, 29, MOVE_SUPERSONIC, 38, MOVE_THUNDER_WAVE, 46, MOVE_SWIFT, 54, MOVE_SCREECH, 0)
    db  "Horse P."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  65,  45,  55,  45,  70, WATER, WATER, 190, 100 ; seel
    MONSTER_GFX MON_WATER_TEKTITE, watertektite
    db  MOVE_HEADBUTT, 0, 0, 0
    dw  INLINE(30, MOVE_GROWL, 35, MOVE_AURORA_BEAM, 40, MOVE_REST, 45, MOVE_TAKE_DOWN, 50, MOVE_ICE_BEAM, 0)
    db  "WTektite"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  60,  50,  70,  70,  80, NORMAL, NORMAL, 50, 50
    MONSTER_GFX MON_FLYING_TILE, flyingtile
    db  MOVE_SELFDESTRUCT, 0, 0, 0
    dw  INLINE(0)
    db  "F.Tile  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  60,  75,  85, 115, 100, WATER, PSYCHIC, 60, 207 ; starmie
    MONSTER_GFX MON_STAR, star
    db  MOVE_TACKLE, MOVE_WATER_GUN, MOVE_HARDEN, 0
    dw  INLINE(0)
    db  "Star    "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS  60,  95,  80,  30,  80, BUG, GRASS, 75, 128 ; parasect
    MONSTER_GFX MON_GOOMBA, goomba
    db  MOVE_SCRATCH, MOVE_STUN_SPORE, MOVE_LEECH_LIFE, 0
    dw  INLINE(13, MOVE_STUN_SPORE, 20, MOVE_LEECH_LIFE, 30, MOVE_SPORE, 39, MOVE_SLASH, 48, MOVE_GROWTH, 0)
    db  "Goomba  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 44,  48,  65,  43,  50, WATER, WATER, 45, 66 ; squirtle
    MONSTER_GFX MON_PEAHAT, peahat
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, 0, 0
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 22, MOVE_BITE, 28, MOVE_WITHDRAW, 35, MOVE_SKULL_BASH, 42, MOVE_HYDRO_PUMP, 0)
    db  "Peahat  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  85,  69,  80,  65, POISON, POISON, 90, 147 ; arbok
    MONSTER_GFX MON_SNAKE, snake
    db  MOVE_WRAP, MOVE_LEER, MOVE_POISON_STING, 0
    dw  INLINE(10, MOVE_POISON_STING, 17, MOVE_BITE, 27, MOVE_GLARE, 36, MOVE_SCREECH, 47, MOVE_ACID, 0)
    db  "Snake   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  90,  50,  55,  85, GRASS, POISON, 120, 151 ; weepinbell
    MONSTER_GFX MON_PIRANHA_PLANT, piranhaplant
    db  MOVE_VINE_WHIP, MOVE_GROWTH, MOVE_WRAP, 0
    dw  INLINE(13, MOVE_WRAP, 15, MOVE_POISONPOWDER, 18, MOVE_SLEEP_POWDER, 23, MOVE_STUN_SPORE, 29, MOVE_ACID, 38, MOVE_RAZOR_LEAF, 49, MOVE_SLAM, 0)
    db  "P.Plant "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 130,  85,  80,  60,  95, WATER, ICE, 45, 219 ; lapras
    MONSTER_GFX MON_BLOOPER, blooper
    db  MOVE_WATER_GUN, MOVE_GROWL, 0, 0
    dw  INLINE(16, MOVE_SING, 20, MOVE_MIST, 25, MOVE_BODY_SLAM, 31, MOVE_CONFUSE_RAY, 38, MOVE_ICE_BEAM, 46, MOVE_HYDRO_PUMP, 0)
    db  "Blooper "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 90,  70,  80,  70,  95, WATER, ICE, 75, 176 ; dewgong
    MONSTER_GFX MON_CHEEP_CHEEP, cheepcheep
    db  MOVE_HEADBUTT, MOVE_GROWL, MOVE_AURORA_BEAM, 0
    dw  INLINE(30, MOVE_GROWL, 35, MOVE_AURORA_BEAM, 44, MOVE_REST, 50, MOVE_TAKE_DOWN, 56, MOVE_ICE_BEAM, 0)
    db  "Ch.Cheep"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 30,  80,  90,  55,  45, ROCK, WATER, 45, 119 ; kabuto
    MONSTER_GFX MON_WINGED_OCTOROK, wingedoctorock
    db  MOVE_SCRATCH, MOVE_HARDEN, 0, 0
    dw  INLINE(34, MOVE_ABSORB, 39, MOVE_SLASH, 44, MOVE_LEER, 49, MOVE_HYDRO_PUMP, 0)
    db  "WOctorck"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 70, 110,  80, 105,  55, BUG, FLYING, 45, 187 ; scyther
    MONSTER_GFX MON_PINCER, pincer
    db  MOVE_QUICK_ATTACK, 0, 0, 0
    dw  INLINE(17, MOVE_LEER, 20, MOVE_FOCUS_ENERGY, 24, MOVE_DOUBLE_TEAM, 29, MOVE_SLASH, 35, MOVE_SWORDS_DANCE, 42, MOVE_AGILITY, 0)
    db  "Pincer  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 35,  70,  55,  25,  55, BUG, GRASS, 190, 70 ; paras
    MONSTER_GFX MON_BEETLE, beetle
    db  MOVE_SCRATCH, 0, 0, 0
    dw  INLINE(13, MOVE_STUN_SPORE, 20, MOVE_LEECH_LIFE, 27, MOVE_SPORE, 34, MOVE_SLASH, 41, MOVE_GROWTH, 0)
    db  "Beetle  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 35,  55,  30,  90,  50, ELECTRIC, ELECTRIC, 190, 82 ; pikachu
    MONSTER_GFX MON_BUZZ_BLOB, buzzblob
    db  MOVE_THUNDERSHOCK, MOVE_GROWL, 0, 0
    dw  INLINE(9, MOVE_THUNDER_WAVE, 16, MOVE_QUICK_ATTACK, 26, MOVE_SWIFT, 33, MOVE_AGILITY, 43, MOVE_THUNDER, 0)
    db  "Buzzblob"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  90,  55, 100,  90, ELECTRIC, ELECTRIC, 75, 122 ; raichu
    MONSTER_GFX MON_CUKEMAN, cukeman
    db  MOVE_THUNDERSHOCK, MOVE_GROWL, MOVE_THUNDER_WAVE, 0
    dw  INLINE(0)
    db  "Cukeman "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 78,  84,  78, 100,  85, FIRE, FLYING, 45, 209 ; charizard
    MONSTER_GFX MON_BOMBER, bomber
    db  MOVE_SCRATCH, MOVE_GROWL, MOVE_EMBER, MOVE_LEER
    dw  INLINE(9, MOVE_EMBER, 15, MOVE_LEER, 24, MOVE_RAGE, 36, MOVE_SLASH, 46, MOVE_FLAMETHROWER, 55, MOVE_FIRE_SPIN, 0)
    db  "Bomber  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 70,  62,  67,  56,  55, POISON, POISON, 120, 117 ; nidorina
    MONSTER_GFX MON_BUSH_CRAWLER, spinybeetle
    db  MOVE_GROWL, MOVE_TACKLE, MOVE_SCRATCH, 0
    dw  INLINE(8, MOVE_SCRATCH, 14, MOVE_POISON_STING, 23, MOVE_TAIL_WHIP, 32, MOVE_BITE, 41, MOVE_FURY_SWIPES, 50, MOVE_DOUBLE_KICK, 0)
    db  "BCrawler"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  95,  57,  93,  85, FIRE, FIRE, 45, 167 ; magmar
    MONSTER_GFX MON_VIRE, vire
    db  MOVE_EMBER, 0, 0, 0
    dw  INLINE(36, MOVE_LEER, 39, MOVE_CONFUSE_RAY, 43, MOVE_FIRE_PUNCH, 48, MOVE_SMOKESCREEN, 52, MOVE_SMOG, 55, MOVE_FLAMETHROWER, 0)
    db  "Vire    "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 10,  55,  25,  95,  45, GROUND, GROUND, 255, 81 ; diglett
    MONSTER_GFX MON_ZOMBIE, zombie
    db  MOVE_SCRATCH, 0, 0, 0
    dw  INLINE(15, MOVE_GROWL, 19, MOVE_DIG, 24, MOVE_SAND_ATTACK, 31, MOVE_SLASH, 40, MOVE_EARTHQUAKE, 0)
    db  "Zombie  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  55, 115,  60, 100, GRASS, GRASS, 45, 166 ; tangela
    MONSTER_GFX MON_URCHIN, urchin
    db  MOVE_CONSTRICT, MOVE_BIND, 0, 0
    dw  INLINE(29, MOVE_ABSORB, 32, MOVE_POISONPOWDER, 36, MOVE_STUN_SPORE, 39, MOVE_SLEEP_POWDER, 45, MOVE_SLAM, 49, MOVE_GROWTH, 0)
    db  "Urchin  "

   ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 30, 105,  90,  50,  25, WATER, WATER, 225, 115 ; krabby
    MONSTER_GFX MON_SAND_CRAB, crab
    db  MOVE_BUBBLE, MOVE_LEER, 0, 0
    dw  INLINE(20, MOVE_VICEGRIP, 25, MOVE_GUILLOTINE, 30, MOVE_STOMP, 35, MOVE_CRABHAMMER, 40, MOVE_HARDEN, 0)
    db  "SandCrab"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 80,  92,  65,  68,  80, WATER, WATER, 60, 170 ; seaking
    MONSTER_GFX MON_ZORA, zora
    db  MOVE_PECK, MOVE_TAIL_WHIP, MOVE_SUPERSONIC, 0
    dw  INLINE(19, MOVE_SUPERSONIC, 24, MOVE_HORN_ATTACK, 30, MOVE_FURY_ATTACK, 39, MOVE_WATERFALL, 48, MOVE_HORN_DRILL, 54, MOVE_AGILITY, 0)
    db  "Zora    "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 20,  10,  55,  80,  20, WATER, WATER, 255, 20 ; magikarp
    MONSTER_GFX MON_FISH, piranha
    db  MOVE_SPLASH, 0, 0, 0
    dw  INLINE(15, MOVE_TACKLE, 0)
    db  "Fish    "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 50,  95, 180,  70,  85, WATER, ICE, 60, 203 ; cloyster
    MONSTER_GFX MON_THWIMP, thwomp
    db  MOVE_WITHDRAW, MOVE_SUPERSONIC, MOVE_CLAMP, MOVE_AURORA_BEAM
    dw  INLINE(50, MOVE_SPIKE_CANNON, 0)
    db  "Thwimp  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 50,  95, 180,  70,  85, WATER, ICE, 60, 203 ; cloyster
    MONSTER_GFX MON_THWOMP, thwomp
    db  MOVE_WITHDRAW, MOVE_SUPERSONIC, MOVE_CLAMP, MOVE_AURORA_BEAM
    dw  INLINE(50, MOVE_SPIKE_CANNON, 0)
    db  "Thwomp  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  60,  70,  40,  75, NORMAL, NORMAL, 45, 130 ; porygon
    MONSTER_GFX MON_GIANT_THWOMP, thwomp
    db  MOVE_TACKLE, MOVE_SHARPEN, MOVE_CONVERSION, 0
    dw  INLINE(23, MOVE_PSYBEAM, 28, MOVE_RECOVER, 35, MOVE_AGILITY, 42, MOVE_TRI_ATTACK, 0)
    db  "B.Thwomp"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 79,  83, 100,  78,  85, WATER, WATER, 45, 210 ; blastoise
    MONSTER_GFX MON_PODOBOO, podoboo
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, MOVE_BUBBLE, MOVE_WATER_GUN
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 24, MOVE_BITE, 31, MOVE_WITHDRAW, 42, MOVE_SKULL_BASH, 52, MOVE_HYDRO_PUMP, 0)
    db  "Podoboo "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    ;MONSTER_STATS 140,  70,  45,  45,  50, NORMAL, NORMAL, 50, 109 ; wigglytuff
    ;MONSTER_GFX MON_GIANT_BUBBLE, giantbubble
    ;db  MOVE_SING, MOVE_DISABLE, MOVE_DEFENSE_CURL, MOVE_DOUBLESLAP
    ;dw  INLINE(0)
    ;db  "Bubble  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 75, 100,  95, 110,  70, NORMAL, NORMAL, 45, 211 ; tauros
    MONSTER_GFX MON_MONKEY, monkey
    db  MOVE_TACKLE, 0, 0, 0
    dw  INLINE(21, MOVE_STOMP, 28, MOVE_TAIL_WHIP, 35, MOVE_LEER, 44, MOVE_RAGE, 51, MOVE_TAKE_DOWN, 0)
    db  "Monkey  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 95,  95,  85,  55, 125, GRASS, PSYCHIC, 45, 212 ; exeggutor
    MONSTER_GFX MON_POKEY, pokey
    db  MOVE_BARRAGE, MOVE_HYPNOSIS, 0, 0
    dw  INLINE(28, MOVE_STOMP, 0)
    db  "Pokey   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 59,  63,  80,  58,  65, WATER, WATER, 45, 143 ; wartortle
    MONSTER_GFX MON_RED_ORB, redorb
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, MOVE_BUBBLE, 0
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 24, MOVE_BITE, 31, MOVE_WITHDRAW, 39, MOVE_SKULL_BASH, 47, MOVE_HYDRO_PUMP, 0)
    db  "Red S.  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 59,  63,  80,  58,  65, WATER, WATER, 45, 143 ; wartortle
    MONSTER_GFX MON_GREEN_ORB, greenorb
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, MOVE_BUBBLE, 0
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 24, MOVE_BITE, 31, MOVE_WITHDRAW, 39, MOVE_SKULL_BASH, 47, MOVE_HYDRO_PUMP, 0)
    db  "Green S."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 59,  63,  80,  58,  65, WATER, WATER, 45, 143 ; wartortle
    MONSTER_GFX MON_BLUE_ORB, blueorb
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, MOVE_BUBBLE, 0
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 24, MOVE_BITE, 31, MOVE_WITHDRAW, 39, MOVE_SKULL_BASH, 47, MOVE_HYDRO_PUMP, 0)
    db  "Blue S. "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  55,  50,  45,  40, BUG, POISON, 190, 75 ; venonat
    MONSTER_GFX MON_RED_CAMO, redcamo
    db  MOVE_TACKLE, MOVE_DISABLE, 0, 0
    dw  INLINE(24, MOVE_POISONPOWDER, 27, MOVE_LEECH_LIFE, 30, MOVE_STUN_SPORE, 35, MOVE_PSYBEAM, 38, MOVE_SLEEP_POWDER, 43, MOVE_PSYCHIC_M, 0)
    db  "Red C.  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  55,  50,  45,  40, BUG, POISON, 190, 75 ; venonat
    MONSTER_GFX MON_GREEN_CAMO, greencamo
    db  MOVE_TACKLE, MOVE_DISABLE, 0, 0
    dw  INLINE(24, MOVE_POISONPOWDER, 27, MOVE_LEECH_LIFE, 30, MOVE_STUN_SPORE, 35, MOVE_PSYBEAM, 38, MOVE_SLEEP_POWDER, 43, MOVE_PSYCHIC_M, 0)
    db  "Green C."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  55,  50,  45,  40, BUG, POISON, 190, 75 ; venonat
    MONSTER_GFX MON_BLUE_CAMO, bluecamo
    db  MOVE_TACKLE, MOVE_DISABLE, 0, 0
    dw  INLINE(24, MOVE_POISONPOWDER, 27, MOVE_LEECH_LIFE, 30, MOVE_STUN_SPORE, 35, MOVE_PSYBEAM, 38, MOVE_SLEEP_POWDER, 43, MOVE_PSYCHIC_M, 0)
    db  "Green C."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 40,  45,  40,  56,  35, NORMAL, FLYING, 255, 55 ; pidgey
    MONSTER_GFX MON_HOPPER, boneputter
    db  MOVE_GUST, 0, 0, 0
    dw  INLINE(5, MOVE_SAND_ATTACK, 12, MOVE_QUICK_ATTACK, 19, MOVE_WHIRLWIND, 28, MOVE_WING_ATTACK, 36, MOVE_AGILITY, 44, MOVE_MIRROR_MOVE, 0)
    db  "Hopper  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65, 125, 100,  85,  55, BUG, BUG, 45, 200 ; pinsir
    MONSTER_GFX MON_GHOMA, ghoma
    db  MOVE_VICEGRIP, 0, 0, 0
    dw  INLINE(25, MOVE_SEISMIC_TOSS, 30, MOVE_GUILLOTINE, 36, MOVE_FOCUS_ENERGY, 43, MOVE_HARDEN, 49, MOVE_SLASH, 54, MOVE_SWORDS_DANCE, 0)
    db  "Ghoma   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 46,  57,  40,  50,  40, POISON, POISON, 235, 60 ; nidoranm
    MONSTER_GFX MON_MASTER_STALFOS, masterstalfos
    db  MOVE_LEER, MOVE_TACKLE, 0, 0
    dw  INLINE(8, MOVE_HORN_ATTACK, 14, MOVE_POISON_STING, 21, MOVE_FOCUS_ENERGY, 29, MOVE_FURY_ATTACK, 36, MOVE_HORN_DRILL, 43, MOVE_DOUBLE_KICK, 0)
    db  "MStalfos"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 95, 125,  79,  81, 100, WATER, FLYING, 45, 214 ; gyarados
    MONSTER_GFX MON_DODONGO_SNAKE, dodongo
    db  MOVE_BITE, MOVE_DRAGON_RAGE, MOVE_LEER, MOVE_HYDRO_PUMP
    dw  INLINE(20, MOVE_BITE, 25, MOVE_DRAGON_RAGE, 32, MOVE_LEER, 41, MOVE_HYDRO_PUMP, 52, MOVE_HYPER_BEAM, 0)
    db  "Dodongo "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 90,  82,  87,  76,  75, POISON, GROUND, 45, 194 ; nidoqueen
    MONSTER_GFX MON_TURTLE_ROCK_HEAD, turtlerockhead
    db  MOVE_TACKLE, MOVE_SCRATCH, MOVE_TAIL_WHIP, MOVE_BODY_SLAM
    dw  INLINE(8, MOVE_SCRATCH, 14, MOVE_POISON_STING, 23, MOVE_BODY_SLAM, 0)
    db  "T.R.Head"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  62,  63,  60,  80, GRASS, POISON, 45, 141 ; ivysaur
    MONSTER_GFX MON_ROLLING_BONES, rollingbones
    db  MOVE_TACKLE, MOVE_GROWL, MOVE_LEECH_SEED, 0
    dw  INLINE(7, MOVE_LEECH_SEED, 13, MOVE_VINE_WHIP, 22, MOVE_POISONPOWDER, 30, MOVE_RAZOR_LEAF, 38, MOVE_GROWTH, 46, MOVE_SLEEP_POWDER, 54, MOVE_SOLARBEAM, 0)
    db  "R.Bones "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 61,  84,  65,  70,  70, DRAGON, DRAGON, 45, 144 ; dragonair
    MONSTER_GFX MON_DESERT_LANMOLA, lanmola
    db  MOVE_WRAP, MOVE_LEER, MOVE_THUNDER_WAVE, 0
    dw  INLINE(10, MOVE_THUNDER_WAVE, 20, MOVE_AGILITY, 35, MOVE_SLAM, 45, MOVE_DRAGON_RAGE, 55, MOVE_HYPER_BEAM, 0)
    db  "Lanmola "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 79,  83, 100,  78,  85, WATER, WATER, 45, 210 ; blastoise
    MONSTER_GFX MON_ARMOS_KNIGHT, armosknight
    db  MOVE_TACKLE, MOVE_TAIL_WHIP, MOVE_BUBBLE, MOVE_WATER_GUN
    dw  INLINE(8, MOVE_BUBBLE, 15, MOVE_WATER_GUN, 24, MOVE_BITE, 31, MOVE_WITHDRAW, 42, MOVE_SKULL_BASH, 52, MOVE_HYDRO_PUMP, 0)
    db  "A.Knight"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  70,  60, 115,  65, NORMAL, NORMAL, 90, 148 ; persian
    MONSTER_GFX MON_HINOX, hinox
    db  MOVE_SCRATCH, MOVE_GROWL, MOVE_BITE, MOVE_SCREECH
    dw  INLINE(12, MOVE_BITE, 17, MOVE_PAY_DAY, 24, MOVE_SCREECH, 37, MOVE_FURY_SWIPES, 51, MOVE_SLASH, 0)
    db  "Hinox   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  48,  45,  42,  90, PSYCHIC, PSYCHIC, 190, 102 ; drowzee
    MONSTER_GFX MON_CUE_BALL, cueball
    db  MOVE_POUND, MOVE_HYPNOSIS, 0, 0
    dw  INLINE(12, MOVE_DISABLE, 17, MOVE_CONFUSION, 24, MOVE_HEADBUTT, 29, MOVE_POISON_GAS, 32, MOVE_PSYCHIC_M, 37, MOVE_MEDITATE, 0)
    db  "Cueball "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 80,  82,  78,  85,  80, WATER, WATER, 75, 174 ; golduck
    MONSTER_GFX MON_SMASHER, smasher
    db  MOVE_SCRATCH, MOVE_TAIL_WHIP, MOVE_DISABLE, 0
    dw  INLINE(28, MOVE_TAIL_WHIP, 31, MOVE_DISABLE, 39, MOVE_CONFUSION, 48, MOVE_FURY_SWIPES, 59, MOVE_HYDRO_PUMP, 0)
    db  "Smasher "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 55,  47,  52,  41,  40, POISON, POISON, 235, 59 ; nidoranf
    MONSTER_GFX MON_GRIM_CREEPER, grimcreeper
    db  MOVE_GROWL, MOVE_TACKLE, 0, 0
    dw  INLINE(8, MOVE_SCRATCH, 14, MOVE_POISON_STING, 21, MOVE_TAIL_WHIP, 29, MOVE_BITE, 36, MOVE_FURY_SWIPES, 43, MOVE_DOUBLE_KICK, 0)
    db  "Grim.C. "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  40,  80,  40,  60, GRASS, PSYCHIC, 90, 98 ; exeggcute
    MONSTER_GFX MON_BLAINO, blaino
    db  MOVE_BARRAGE, MOVE_HYPNOSIS, 0, 0
    dw  INLINE(25, MOVE_REFLECT, 28, MOVE_LEECH_SEED, 32, MOVE_STUN_SPORE, 37, MOVE_POISONPOWDER, 42, MOVE_SOLARBEAM, 48, MOVE_SLEEP_POWDER, 0)
    db  "Blaino  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 105, 130, 120,  40,  45, GROUND, ROCK, 60, 204 ; rhydon
    MONSTER_GFX MON_MOBLIN_KING, moblinking
    db  MOVE_HORN_ATTACK, MOVE_STOMP, MOVE_TAIL_WHIP, MOVE_FURY_ATTACK
    dw  INLINE(30, MOVE_STOMP, 35, MOVE_TAIL_WHIP, 40, MOVE_FURY_ATTACK, 48, MOVE_HORN_DRILL, 55, MOVE_LEER, 64, MOVE_TAKE_DOWN, 0)
    db  "M.King  "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 55,  70,  45,  60,  50, FIRE, FIRE, 190, 91 ; growlithe
    MONSTER_GFX MON_AVALAUNCH, stonehinox
    db  MOVE_BITE, MOVE_ROAR, 0, 0
    dw  INLINE(18, MOVE_EMBER, 23, MOVE_LEER, 30, MOVE_TAKE_DOWN, 39, MOVE_AGILITY, 50, MOVE_FLAMETHROWER, 0)
    db  "S.Hinox "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 65,  65,  65,  90,  50, WATER, WATER, 120, 131 ; poliwhirl
    MONSTER_GFX MON_GIANT_BUZZ_BLOB, giantbuzzblob
    db  MOVE_BUBBLE, MOVE_HYPNOSIS, MOVE_WATER_GUN, 0
    dw  INLINE(16, MOVE_HYPNOSIS, 19, MOVE_WATER_GUN, 26, MOVE_DOUBLESLAP, 33, MOVE_BODY_SLAM, 41, MOVE_AMNESIA, 49, MOVE_HYDRO_PUMP, 0)
    db  "GiantBB."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 80,  70,  65, 100, 120, WATER, POISON, 60, 205 ; tentacruel
    MONSTER_GFX MON_MOLDORM, moldorm
    db  MOVE_ACID, MOVE_SUPERSONIC, MOVE_WRAP, 0
    dw  INLINE(7, MOVE_SUPERSONIC, 13, MOVE_WRAP, 18, MOVE_POISON_STING, 22, MOVE_WATER_GUN, 27, MOVE_CONSTRICT, 35, MOVE_BARRIER, 43, MOVE_SCREECH, 50, MOVE_HYDRO_PUMP, 0)
    db  "Moldorm "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 40,  65,  95,  35,  60, POISON, POISON, 190, 114 ; koffing
    MONSTER_GFX MON_FACADE, facade
    db  MOVE_TACKLE, MOVE_SMOG, 0, 0
    dw  INLINE(32, MOVE_SLUDGE, 37, MOVE_SMOKESCREEN, 40, MOVE_SELFDESTRUCT, 45, MOVE_HAZE, 48, MOVE_EXPLOSION, 0)
    db  "Facade  "


    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 60,  65,  70,  40,  85, GRASS, POISON, 120, 132 ; gloom
    MONSTER_GFX MON_SLIME_EYE, slimeeye
    db  MOVE_ABSORB, MOVE_POISONPOWDER, MOVE_STUN_SPORE, 0
    dw  INLINE(15, MOVE_POISONPOWDER, 17, MOVE_STUN_SPORE, 19, MOVE_SLEEP_POWDER, 28, MOVE_ACID, 38, MOVE_PETAL_DANCE, 52, MOVE_SOLARBEAM, 0)
    db  "S.Eye   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 55,  50,  45, 120, 135, PSYCHIC, PSYCHIC, 50, 186 ; alakazam
    MONSTER_GFX MON_GENIE, genie
    db  MOVE_TELEPORT, MOVE_CONFUSION, MOVE_DISABLE, 0
    dw  INLINE(16, MOVE_CONFUSION, 20, MOVE_DISABLE, 27, MOVE_PSYBEAM, 31, MOVE_RECOVER, 38, MOVE_PSYCHIC_M, 42, MOVE_REFLECT, 0)
    db  "Genie   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 90,  90,  85, 100, 125, ELECTRIC, FLYING, 3, 216 ; zapdos
    MONSTER_GFX MON_SLIME_EEL, slimeeel
    db  MOVE_THUNDERSHOCK, MOVE_DRILL_PECK, 0, 0
    dw  INLINE(51, MOVE_THUNDER, 55, MOVE_AGILITY, 60, MOVE_LIGHT_SCREEN, 0)
    db  "S.Eel   "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 38,  41,  40,  65,  65, FIRE, FIRE, 190, 63 ; vulpix
    MONSTER_GFX MON_HOT_HEAD, hothead
    db  MOVE_EMBER, MOVE_TAIL_WHIP, 0, 0
    dw  INLINE(16, MOVE_QUICK_ATTACK, 21, MOVE_ROAR, 28, MOVE_CONFUSE_RAY, 35, MOVE_FLAMETHROWER, 42, MOVE_FIRE_SPIN, 0)
    db  "Hot head"

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 80, 105,  65, 130,  60, ROCK, FLYING, 45, 202 ; aerodactyl
    MONSTER_GFX MON_EVIL_EAGLE, evileagle
    db  MOVE_WING_ATTACK, MOVE_AGILITY, 0, 0
    dw  INLINE(33, MOVE_SUPERSONIC, 38, MOVE_BITE, 45, MOVE_TAKE_DOWN, 54, MOVE_HYPER_BEAM, 0)
    db  "E.Eagle "

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 35,  40, 100,  35,  90, ROCK, WATER, 45, 120 ; omanyte
    MONSTER_GFX MON_ANGLER_FISH, anglerfish
    db  MOVE_WATER_GUN, MOVE_WITHDRAW, 0, 0
    dw  INLINE(34, MOVE_HORN_ATTACK, 39, MOVE_LEER, 46, MOVE_SPIKE_CANNON, 53, MOVE_HYDRO_PUMP, 0)
    db  "AnglerF."

    ;              hp  atk  def  spd  spc type1 type2 catch exp
    MONSTER_STATS 55, 130, 115,  75,  50, WATER, WATER, 60, 206 ; kingler
    MONSTER_GFX MON_HARDHIT_BEETLE, hardhitbeetle
    db  MOVE_BUBBLE, MOVE_LEER, MOVE_VICEGRIP, 0
    dw  INLINE(20, MOVE_VICEGRIP, 25, MOVE_GUILLOTINE, 34, MOVE_STOMP, 42, MOVE_CRABHAMMER, 49, MOVE_HARDEN, 0)
    db  "H.H.B.  "
