// Description:
//  OUT = 0, 5, 10, ... 245, 255, 255, 245, ... 5, 0
//  https://youtu.be/Zg1NdPKoosU

// Load increment value
LDI 5   // A = X,  increment value
STA 15  // M[Y] = X

LDI 0   // A = 0,  initial value

// Increase
OUT
ADD 15  // A += M[15]
JC 7    // if overflows, start decreasing (instr7)
JMP 3   // otherwise, continue increasing (instr3)

// Decrease
SUB 15  // A -= M[15]
OUT
JZ 3    // if reach zero, start increasing (instr3)
JMP 7   // otherwise, continue decreasing (instr7)
