// Description:
//  OUT = 0, 5, 10, ... 245, 255, 255, 245, ... 5, 0

// Load increment value
LDI 5   // A = X,  increment value
STA 15  // M[Y] = X

LDI 0   // A = 0,  initial value

// Increase
OUT
ADD 15  // A += M[15]
JC 4    // if overflows, start decreasing (instr4)
JMP 0   // otherwise, continue increasing (instr0)

// Decrease
SUB 15  // A -= M[15]
OUT
JZ 0    // if reach zero, start increasing (instr0)
JMP 4   // otherwise, continue decreasing (instr4)
