// Description:
//  OUT = Greetings!\nYou got here just in time!\n
//  Useful for communication testing ... i.e. search for dropped bytes

LDI 1   // increment by
STA 15  // M[15] = 1

LDI 0   // start value
STA 14  // M[14] = 0

LDA 14  // A = M[14]
ADD 15  // A += M[15]
STA 14  // M[14] = A
OUT

LDI 10  // A = M[10]
OUT

JMP 4   // loop indefinitely



LDA G - 1  // init

ADD inc
OUT


LDI 1  // increment by
STA


// Doing this manually.
// Code can be made more consise by using conditional jumps (allows for terminable loop).
// At the time of writing, none available.

LDI 71   // G
OUT
LDI 114  // r
OUT
LDI 101  // e
OUT
LDI 101  // e
OUT
LDI 116  // t
OUT
LDI 105  // i
OUT
LDI 110  // n
OUT
LDI 103  // g
OUT
LDI 115  // s
OUT
LDI 33   // !
OUT
LDI 10   // \n
OUT
LDI 89   // Y
OUT
LDI 111  // o
OUT
LDI 117  // u
OUT
LDI 32   //   
OUT
LDI 103  // g
OUT
LDI 111  // o
OUT
LDI 116  // t
OUT
LDI 32   // 
OUT
LDI 104  // h
OUT
LDI 101  // e
OUT
LDI 114  // r
OUT
LDI 101  // e
OUT
LDI 32   // 
OUT
LDI 106  // j
OUT
LDI 117  // u
OUT
LDI 115  // s
OUT
LDI 116  // t
OUT
LDI 32   // 
OUT
LDI 105  // i
OUT
LDI 110  // n
OUT
LDI 32   // 
OUT
LDI 116  // t
OUT
LDI 105  // i
OUT
LDI 109  // m
OUT
LDI 101  // e
OUT
LDI 33   // !
OUT
LDI 10   // \n
OUT
LDI 10   // \n
OUT

JMP 0    // loop indefinitely
