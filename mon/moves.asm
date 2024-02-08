#MACRO move
    dw \1
    db \2, \3, \4, \5, \6
#END

movesTable:
    ;    Label            Effect                    Power  Type     Accuracy  pp
    move i"-",            NO_ADDITIONAL_EFFECT,         0, NORMAL,         0, 0
    move i"Pound",        NO_ADDITIONAL_EFFECT,        40, NORMAL,       100, 35
    move i"Karate chop",  NO_ADDITIONAL_EFFECT,        50, NORMAL,       100, 25
    move i"Doubleslap",   TWO_TO_FIVE_ATTACKS_EFFECT,  15, NORMAL,        85, 10
    move i"Comet punch",  TWO_TO_FIVE_ATTACKS_EFFECT,  18, NORMAL,        85, 15
    move i"Mega punch",   NO_ADDITIONAL_EFFECT,        80, NORMAL,        85, 20
    move i"Pay day",      PAY_DAY_EFFECT,              40, NORMAL,       100, 20
    move i"Fire punch",   BURN_SIDE_EFFECT1,           75, FIRE,         100, 15
    move i"Ice punch",    FREEZE_SIDE_EFFECT,          75, ICE,          100, 15
    move i"Thunderpunch", PARALYZE_SIDE_EFFECT1,       75, ELECTRIC,     100, 15
    move i"Scratch",      NO_ADDITIONAL_EFFECT,        40, NORMAL,       100, 35
    move i"Vicegrip",     NO_ADDITIONAL_EFFECT,        55, NORMAL,       100, 30
    move i"Guillotine",   OHKO_EFFECT,                  1, NORMAL,        30,  5
    move i"Razor wind",   CHARGE_EFFECT,               80, NORMAL,        75, 10
    move i"Swords dance", ATTACK_UP2_EFFECT,            0, NORMAL,       100, 30
    move i"Cut",          NO_ADDITIONAL_EFFECT,        50, NORMAL,        95, 30
    move i"Gust",         NO_ADDITIONAL_EFFECT,        40, NORMAL,       100, 35
    move i"Wing attack",  NO_ADDITIONAL_EFFECT,        35, FLYING,       100, 35
    move i"Whirlwind",    SWITCH_AND_TELEPORT_EFFECT,   0, NORMAL,        85, 20
    move i"Fly",          FLY_EFFECT,                  70, FLYING,        95, 15
    move i"Bind",         TRAPPING_EFFECT,             15, NORMAL,        75, 20
    move i"Slam",         NO_ADDITIONAL_EFFECT,        80, NORMAL,        75, 20
    move i"Vine whip",    NO_ADDITIONAL_EFFECT,        35, GRASS,        100, 10
    move i"Stomp",        FLINCH_SIDE_EFFECT2,         65, NORMAL,       100, 20
    move i"Double kick",  ATTACK_TWICE_EFFECT,         30, FIGHTING,     100, 30
    move i"Mega kick",    NO_ADDITIONAL_EFFECT,       120, NORMAL,        75,  5
    move i"Jump kick",    JUMP_KICK_EFFECT,            70, FIGHTING,      95, 25
    move i"Rolling kick", FLINCH_SIDE_EFFECT2,         60, FIGHTING,      85, 15
    move i"Sand attack",  ACCURACY_DOWN1_EFFECT,        0, NORMAL,       100, 15
    move i"Headbutt",     FLINCH_SIDE_EFFECT2,         70, NORMAL,       100, 15
    move i"Horn attack",  NO_ADDITIONAL_EFFECT,        65, NORMAL,       100, 25
    move i"Fury attack",  TWO_TO_FIVE_ATTACKS_EFFECT,  15, NORMAL,        85, 20
    move i"Horn drill",   OHKO_EFFECT,                  1, NORMAL,        30,  5
    move i"Tackle",       NO_ADDITIONAL_EFFECT,        35, NORMAL,        95, 35
    move i"Body slam",    PARALYZE_SIDE_EFFECT2,       85, NORMAL,       100, 15
    move i"Wrap",         TRAPPING_EFFECT,             15, NORMAL,        85, 20
    move i"Take down",    RECOIL_EFFECT,               90, NORMAL,        85, 20
    move i"Thrash",       THRASH_PETAL_DANCE_EFFECT,   90, NORMAL,       100, 20
    move i"Double edge",  RECOIL_EFFECT,              100, NORMAL,       100, 15
    move i"Tail whip",    DEFENSE_DOWN1_EFFECT,         0, NORMAL,       100, 30
    move i"Poison sting", POISON_SIDE_EFFECT1,         15, POISON,       100, 35
    move i"Twineedle",    TWINEEDLE_EFFECT,            25, BUG,          100, 20
    move i"Pin missile",  TWO_TO_FIVE_ATTACKS_EFFECT,  14, BUG,           85, 20
    move i"Leer",         DEFENSE_DOWN1_EFFECT,         0, NORMAL,       100, 30
    move i"Bite",         FLINCH_SIDE_EFFECT1,         60, NORMAL,       100, 25
    move i"Growl",        ATTACK_DOWN1_EFFECT,          0, NORMAL,       100, 40
    move i"Roar",         SWITCH_AND_TELEPORT_EFFECT,   0, NORMAL,       100, 20
    move i"Sing",         SLEEP_EFFECT,                 0, NORMAL,        55, 15
    move i"Supersonic",   CONFUSION_EFFECT,             0, NORMAL,        55, 20
    move i"Sonicboom",    SPECIAL_DAMAGE_EFFECT,        1, NORMAL,        90, 20
    move i"Disable",      DISABLE_EFFECT,               0, NORMAL,        55, 20
    move i"Acid",         DEFENSE_DOWN_SIDE_EFFECT,    40, POISON,       100, 30
    move i"Ember",        BURN_SIDE_EFFECT1,           40, FIRE,         100, 25
    move i"Flamethrower", BURN_SIDE_EFFECT1,           95, FIRE,         100, 15
    move i"Mist",         MIST_EFFECT,                  0, ICE,          100, 30
    move i"Water gun",    NO_ADDITIONAL_EFFECT,        40, WATER,        100, 25
    move i"Hydro pump",   NO_ADDITIONAL_EFFECT,       120, WATER,         80,  5
    move i"Surf",         NO_ADDITIONAL_EFFECT,        95, WATER,        100, 15
    move i"Ice beam",     FREEZE_SIDE_EFFECT,          95, ICE,          100, 10
    move i"Blizzard",     FREEZE_SIDE_EFFECT,         120, ICE,           90,  5
    move i"Psybeam",      CONFUSION_SIDE_EFFECT,       65, PSYCHIC,      100, 20
    move i"Bubblebeam",   SPEED_DOWN_SIDE_EFFECT,      65, WATER,        100, 20
    move i"Aurora beam",  ATTACK_DOWN_SIDE_EFFECT,     65, ICE,          100, 20
    move i"Hyper beam",   HYPER_BEAM_EFFECT,          150, NORMAL,        90,  5
    move i"Peck",         NO_ADDITIONAL_EFFECT,        35, FLYING,       100, 35
    move i"Drill peck",   NO_ADDITIONAL_EFFECT,        80, FLYING,       100, 20
    move i"Submission",   RECOIL_EFFECT,               80, FIGHTING,      80, 25
    move i"Low kick",     FLINCH_SIDE_EFFECT2,         50, FIGHTING,      90, 20
    move i"Counter",      NO_ADDITIONAL_EFFECT,         1, FIGHTING,     100, 20
    move i"Seismic toss", SPECIAL_DAMAGE_EFFECT,        1, FIGHTING,     100, 20
    move i"Strength",     NO_ADDITIONAL_EFFECT,        80, NORMAL,       100, 15
    move i"Absorb",       DRAIN_HP_EFFECT,             20, GRASS,        100, 20
    move i"Mega drain",   DRAIN_HP_EFFECT,             40, GRASS,        100, 10
    move i"Leech seed",   LEECH_SEED_EFFECT,            0, GRASS,         90, 10
    move i"Growth",       SPECIAL_UP1_EFFECT,           0, NORMAL,       100, 40
    move i"Razor leaf",   NO_ADDITIONAL_EFFECT,        55, GRASS,         95, 25
    move i"Solarbeam",    CHARGE_EFFECT,              120, GRASS,        100, 10
    move i"Poisonpowder", POISON_EFFECT,                0, POISON,        75, 35
    move i"Stun spore",   PARALYZE_EFFECT,              0, GRASS,         75, 30
    move i"Sleep powder", SLEEP_EFFECT,                 0, GRASS,         75, 15
    move i"Petal dance",  THRASH_PETAL_DANCE_EFFECT,   70, GRASS,        100, 20
    move i"String shot",  SPEED_DOWN1_EFFECT,           0, BUG,           95, 40
    move i"Dragon rage",  SPECIAL_DAMAGE_EFFECT,        1, DRAGON,       100, 10
    move i"Fire spin",    TRAPPING_EFFECT,             15, FIRE,          70, 15
    move i"Thundershock", PARALYZE_SIDE_EFFECT1,       40, ELECTRIC,     100, 30
    move i"Thunderbolt",  PARALYZE_SIDE_EFFECT1,       95, ELECTRIC,     100, 15
    move i"Thunder wave", PARALYZE_EFFECT,              0, ELECTRIC,     100, 20
    move i"Thunder",      PARALYZE_SIDE_EFFECT1,      120, ELECTRIC,      70, 10
    move i"Rock throw",   NO_ADDITIONAL_EFFECT,        50, ROCK,          65, 15
    move i"Earthquake",   NO_ADDITIONAL_EFFECT,       100, GROUND,       100, 10
    move i"Fissure",      OHKO_EFFECT,                  1, GROUND,        30,  5
    move i"Dig",          CHARGE_EFFECT,              100, GROUND,       100, 10
    move i"Toxic",        POISON_EFFECT,                0, POISON,        85, 10
    move i"Confusion",    CONFUSION_SIDE_EFFECT,       50, PSYCHIC,      100, 25
    move i"Psychic m",    SPECIAL_DOWN_SIDE_EFFECT,    90, PSYCHIC,      100, 10
    move i"Hypnosis",     SLEEP_EFFECT,                 0, PSYCHIC,       60, 20
    move i"Meditate",     ATTACK_UP1_EFFECT,            0, PSYCHIC,      100, 40
    move i"Agility",      SPEED_UP2_EFFECT,             0, PSYCHIC,      100, 30
    move i"Quick attack", NO_ADDITIONAL_EFFECT,        40, NORMAL,       100, 30
    move i"Rage",         RAGE_EFFECT,                 20, NORMAL,       100, 20
    move i"Teleport",     SWITCH_AND_TELEPORT_EFFECT,   0, PSYCHIC,      100, 20
    move i"Night shade",  SPECIAL_DAMAGE_EFFECT,        0, GHOST,        100, 15
    move i"Mimic",        MIMIC_EFFECT,                 0, NORMAL,       100, 10
    move i"Screech",      DEFENSE_DOWN2_EFFECT,         0, NORMAL,        85, 40
    move i"Double team",  EVASION_UP1_EFFECT,           0, NORMAL,       100, 15
    move i"Recover",      HEAL_EFFECT,                  0, NORMAL,       100, 20
    move i"Harden",       DEFENSE_UP1_EFFECT,           0, NORMAL,       100, 30
    move i"Minimize",     EVASION_UP1_EFFECT,           0, NORMAL,       100, 20
    move i"Smokescreen",  ACCURACY_DOWN1_EFFECT,        0, NORMAL,       100, 20
    move i"Confuse ray",  CONFUSION_EFFECT,             0, GHOST,        100, 10
    move i"Withdraw",     DEFENSE_UP1_EFFECT,           0, WATER,        100, 40
    move i"Defense curl", DEFENSE_UP1_EFFECT,           0, NORMAL,       100, 40
    move i"Barrier",      DEFENSE_UP2_EFFECT,           0, PSYCHIC,      100, 30
    move i"Light screen", LIGHT_SCREEN_EFFECT,          0, PSYCHIC,      100, 30
    move i"Haze",         HAZE_EFFECT,                  0, ICE,          100, 30
    move i"Reflect",      REFLECT_EFFECT,               0, PSYCHIC,      100, 20
    move i"Focus energy", FOCUS_ENERGY_EFFECT,          0, NORMAL,       100, 30
    move i"Bide",         BIDE_EFFECT,                  0, NORMAL,       100, 10
    move i"Metronome",    METRONOME_EFFECT,             0, NORMAL,       100, 10
    move i"Mirror move",  MIRROR_MOVE_EFFECT,           0, FLYING,       100, 20
    move i"Selfdestruct", EXPLODE_EFFECT,             130, NORMAL,       100,  5
    move i"Egg bomb",     NO_ADDITIONAL_EFFECT,       100, NORMAL,        75, 10
    move i"Lick",         PARALYZE_SIDE_EFFECT2,       20, GHOST,        100, 30
    move i"Smog",         POISON_SIDE_EFFECT2,         20, POISON,        70, 20
    move i"Sludge",       POISON_SIDE_EFFECT2,         65, POISON,       100, 20
    move i"Bone club",    FLINCH_SIDE_EFFECT1,         65, GROUND,        85, 20
    move i"Fire blast",   BURN_SIDE_EFFECT2,          120, FIRE,          85,  5
    move i"Waterfall",    NO_ADDITIONAL_EFFECT,        80, WATER,        100, 15
    move i"Clamp",        TRAPPING_EFFECT,             35, WATER,         75, 10
    move i"Swift",        SWIFT_EFFECT,                60, NORMAL,       100, 20
    move i"Skull bash",   CHARGE_EFFECT,              100, NORMAL,       100, 15
    move i"Spike cannon", TWO_TO_FIVE_ATTACKS_EFFECT,  20, NORMAL,       100, 15
    move i"Constrict",    SPEED_DOWN_SIDE_EFFECT,      10, NORMAL,       100, 35
    move i"Amnesia",      SPECIAL_UP2_EFFECT,           0, PSYCHIC,      100, 20
    move i"Kinesis",      ACCURACY_DOWN1_EFFECT,        0, PSYCHIC,       80, 15
    move i"Softboiled",   HEAL_EFFECT,                  0, NORMAL,       100, 10
    move i"Hi jump kick", JUMP_KICK_EFFECT,            85, FIGHTING,      90, 20
    move i"Glare",        PARALYZE_EFFECT,              0, NORMAL,        75, 30
    move i"Dream eater",  DREAM_EATER_EFFECT,         100, PSYCHIC,      100, 15
    move i"Poison gas",   POISON_EFFECT,                0, POISON,        55, 40
    move i"Barrage",      TWO_TO_FIVE_ATTACKS_EFFECT,  15, NORMAL,        85, 20
    move i"Leech life",   DRAIN_HP_EFFECT,             20, BUG,          100, 15
    move i"Lovely kiss",  SLEEP_EFFECT,                 0, NORMAL,        75, 10
    move i"Sky attack",   CHARGE_EFFECT,              140, FLYING,        90,  5
    move i"Transform",    TRANSFORM_EFFECT,             0, NORMAL,       100, 10
    move i"Bubble",       SPEED_DOWN_SIDE_EFFECT,      20, WATER,        100, 30
    move i"Dizzy punch",  NO_ADDITIONAL_EFFECT,        70, NORMAL,       100, 10
    move i"Spore",        SLEEP_EFFECT,                 0, GRASS,        100, 15
    move i"Flash",        ACCURACY_DOWN1_EFFECT,        0, NORMAL,        70, 20
    move i"Psywave",      SPECIAL_DAMAGE_EFFECT,        1, PSYCHIC,       80, 15
    move i"Splash",       SPLASH_EFFECT,                0, NORMAL,       100, 40
    move i"Acid armor",   DEFENSE_UP2_EFFECT,           0, POISON,       100, 40
    move i"Crabhammer",   NO_ADDITIONAL_EFFECT,        90, WATER,         85, 10
    move i"Explosion",    EXPLODE_EFFECT,             170, NORMAL,       100,  5
    move i"Fury swipes",  TWO_TO_FIVE_ATTACKS_EFFECT,  18, NORMAL,        80, 15
    move i"Bonemerang",   ATTACK_TWICE_EFFECT,         50, GROUND,        90, 10
    move i"Rest",         HEAL_EFFECT,                  0, PSYCHIC,      100, 10
    move i"Rock slide",   NO_ADDITIONAL_EFFECT,        75, ROCK,          90, 10
    move i"Hyper fang",   FLINCH_SIDE_EFFECT1,         80, NORMAL,        90, 15
    move i"Sharpen",      ATTACK_UP1_EFFECT,            0, NORMAL,       100, 30
    move i"Conversion",   CONVERSION_EFFECT,            0, NORMAL,       100, 30
    move i"Tri attack",   NO_ADDITIONAL_EFFECT,        80, NORMAL,       100, 10
    move i"Super fang",   SUPER_FANG_EFFECT,            1, NORMAL,        90, 10
    move i"Slash",        NO_ADDITIONAL_EFFECT,        70, NORMAL,       100, 20
    move i"Substitute",   SUBSTITUTE_EFFECT,            0, NORMAL,       100, 10
    move i"Struggle",     RECOIL_EFFECT,               50, NORMAL,       100, 10
