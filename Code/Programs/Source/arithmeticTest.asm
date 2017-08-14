// Description:
//	OUT = M[15] + M[14] - M[13]


// Load some values onto ram
LDI 5   // A = X
STA 15  // M[Y] = X

LDI 2   // A = X
STA 14  // M[Y] = X

LDI 15  // A = X
STA 13  // M[Y] = X


// Do the math
LDA 15  // A  = M[15]
ADD 14  // A += M[14]
SUB 13  // A -= M[13]
OUT
HLT
