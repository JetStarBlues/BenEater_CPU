// OUT = multiples of 3

LDI 3
STA 15  // M[15] = 3
LDI 0   // A = 0
ADD 15  // A += M[15]
OUT
JMP 3   // loop indefinitely