.text
.globl main
main:
    # #######################################
    # STEP 1: Zero registers x1–x31
    # #######################################
    xor x1, x0, x0
    xor x2, x0, x0
    xor x3, x0, x0
    xor x4, x0, x0
    xor x5, x0, x0
    xor x6, x0, x0
    xor x7, x0, x0
    xor x8, x0, x0
    xor x9, x0, x0
    xor x10, x0, x0
    xor x11, x0, x0
    xor x12, x0, x0
    xor x13, x0, x0
    xor x14, x0, x0
    xor x15, x0, x0
    xor x16, x0, x0
    xor x17, x0, x0
    xor x18, x0, x0
    xor x19, x0, x0
    xor x20, x0, x0
    xor x21, x0, x0
    xor x22, x0, x0
    xor x23, x0, x0
    xor x24, x0, x0
    xor x25, x0, x0
    xor x26, x0, x0
    xor x27, x0, x0
    xor x28, x0, x0
    xor x29, x0, x0
    xor x30, x0, x0
    xor x31, x0, x0


    # ###########################################################
    # STEP 2: Build ASCII constants for:
    #   "stacks from all sides"
    # ###########################################################

    # x1 <- "stac" = 0x73746163
    lui  x1, 0x73746
    add  x1, x1, x0
    ori  x1, x1, 0x163

    # x2 <- "ks f" = 0x6B732066
    lui  x2, 0x6B732
    xor  x2, x2, x0
    addi x2, x2, 0x66

    # x3 <- "rom " = 0x726F6D20
    lui  x3, 0x726F7         
    addi x3, x3, -736 

    # x4 <- "all " = 0x616C6C20
    lui  x4, 0x616C7
    addi x4, x4, -992
    # x5 <- "side" = 0x73696465
    lui  x5, 0x73696
    xor  x5, x5, x0
    addi x5, x5, 0x465

    # x6 <- "s" = 0x73
    lui  x6, 0x73
    slli x6, x6, 12


    # #######################################
    # STEP 3: HALT
    # #######################################
halt:
    j halt
    ebreak
    
