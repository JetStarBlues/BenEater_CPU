# ==============================================================================
# 
#  Attribution:
# 
#     Code by www.jk-quantized.com
# 
#  Redistribution and use of this code in source and binary forms must
#  retain the above attribution notice and this condition.
# 
# ==============================================================================

# See https://youtu.be/JUVt_KYAp-I


# Codes -------------------------------------------------------

instructions = [

	# 'NOP', 'LDA', 'ADD', 'SUB',
	# 'STA', 'LDI', 'JMP',  'JC',
	#  'JZ', 'xxx', 'xxx', 'xxx',
	# 'xxx', 'xxx', 'OUT', 'HLT'

	'NOP', 'LDA', 'ADD', 'SUB',
	'STA', 'LDI', 'JMP',  'JC',
	 'JZ', 'xxx', 'xxx', 'xxx',
	'ADI', 'SBI', 'OUT', 'HLT'
]

ucb = [ 'HLT', 'MI', 'RI', 'RO', 'IO', 'II', 'AI', 'AO' ]
lcb = [  'ΣO', 'SU', 'BI', 'OI', 'CE', 'CO',  'J', 'FI' ]

fetch = [ 'CO|MI', 'RO|II|CE' ]

microInstructions_ = [

	[       0,             0,             0, 0, 0, 0 ],  # NOP
	[ 'IO|MI',       'RO|AI',             0, 0, 0, 0 ],  # LDA
	[ 'IO|MI',       'RO|BI',    'ΣO|AI|FI', 0, 0, 0 ],  # ADD
	[ 'IO|MI',       'RO|BI', 'ΣO|AI|SU|FI', 0, 0, 0 ],  # SUB
	[ 'IO|MI',       'AO|RI',             0, 0, 0, 0 ],  # STA
	[ 'IO|AI',             0,             0, 0, 0, 0 ],  # LDI
	[  'IO|J',             0,             0, 0, 0, 0 ],  # JMP
	[       0,             0,             0, 0, 0, 0 ],  # JC
	[       0,             0,             0, 0, 0, 0 ],  # JZ
	[       0,             0,             0, 0, 0, 0 ],  # xxx
	[       0,             0,             0, 0, 0, 0 ],  # xxx
	[       0,             0,             0, 0, 0, 0 ],  # xxx
	[ 'IO|BI',    'ΣO|AI|FI',             0, 0, 0, 0 ],  # ADI, Atm, unofficial instructions
	[ 'IO|BI', 'ΣO|AI|SU|FI',             0, 0, 0, 0 ],  # SBI, Atm, unofficial instructions
	[ 'AO|OI',             0,             0, 0, 0, 0 ],  # OUT
	[   'HLT',             0,             0, 0, 0, 0 ],  # HLT
]

# Account for jump variants
microInstructions = microInstructions_ * 4

# Flags_z0c1
idx = ( 16 * 1 ) + instructions.index( 'JC' )
microInstructions[ idx ] = [ 'IO|J', 0, 0, 0, 0, 0 ]

# Flags_z1c0
idx = ( 16 * 2 ) + instructions.index( 'JZ' )
microInstructions[ idx ] = [ 'IO|J', 0, 0, 0, 0, 0 ]

# Flags_z1c1
idx = ( 16 * 3 ) + instructions.index( 'JC' )
microInstructions[ idx ] = [ 'IO|J', 0, 0, 0, 0, 0 ]
idx = ( 16 * 3 ) + instructions.index( 'JZ' )
microInstructions[ idx ] = [ 'IO|J', 0, 0, 0, 0, 0 ]



# Functions ---------------------------------------------------

def bin2hex( a ):

	h = ''

	if isinstance( a, list ):

		h = int( ''.join( a ), 2 )
		h = hex( h )[2 : ].zfill(2)
	
	elif a == 0:

		h = '00'

	# return h
	return 'x"{}"'.format( h )  # VHDL hex format

def decode( instrs ):

	ucode = []
	lcode = []

	for instr in instrs:

		ub = [ '0' ] * 8
		lb = [ '0' ] * 8

		if instr == 0 :

			ucode.append( bin2hex( instr ) )
			lcode.append( bin2hex( instr ) )

		else:

			bits = instr.split( '|' )

			for b in bits:

				try:

					idx = ucb.index( b )

					ub[ idx ] = '1'

				except ValueError:

					idx = lcb.index( b )

					lb[ idx ] = '1'

			ucode.append( bin2hex( ub ) )
			lcode.append( bin2hex( lb ) )

	return ( ucode, lcode )

def getMicroHex ():

	f = decode( fetch )

	ubytes = []
	lbytes = []

	for instr in microInstructions:

		ubyts = []
		lbyts = []

		ubyts.extend( f[ 0 ] )
		lbyts.extend( f[ 1 ] )

		byts = decode( instr )

		ubyts.extend( byts[ 0 ] )
		lbyts.extend( byts[ 1 ] )

		ubytes.append( ubyts )
		lbytes.append( lbyts )

	return( ubytes, lbytes )


# Print output ------------------------------------------------

code = getMicroHex()

for b in code[0]:
	print( ', '.join( b ), end=',\n' )
print()
for b in code[1]:
	print( ', '.join( b ), end=',\n' )
