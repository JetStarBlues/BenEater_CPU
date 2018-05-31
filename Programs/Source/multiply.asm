// Description:
//  OUT = M[20] * M[21]
//  https://youtu.be/Zg1NdPKoosU
// TODO - Won't work until figure out how to 
//        'STA addr' when 'addr > 15', as program code is 17 lines

// Setup --
LDI 7   // x
STA 20  // M[20] = x

LDI 31  // y
STA 21  // M[21] = y

// M[22] = product

LDI 1
STA 23  // M[23] = 1


// Main --
// loop until x is zero
LDA 20  // x
SUB 23  // x -= 1, "when subtract one from anything but zero, carry bit set" ... "SUB 1 is actually ADD 255"
JC 12   // jump to addition (instr12)

// done
LDA 22  // product
OUT
HLT

// add
STA 20  // update x

LDA 22  // product
ADD 21  // product += y
STA 22

JMP 6   // jump to next iteration (instr6)
