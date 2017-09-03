# See https://youtu.be/JUVt_KYAp-I

ucb = [ 'HLT', 'MI', 'RI', 'RO', 'IO', 'II', 'AI', 'AO' ]
lcb = [  'ΣO', 'SU', 'BI', 'OI', 'CE', 'CO',  'J', '?' ]

microInstructions = [

	[       0,          0,          0 ],  # NOP
	[ 'IO|MI',    'RO|AI',          0 ],  # LDA
	[ 'IO|MI',    'RO|BI',    'ΣO|AI' ],  # ADD
	[ 'IO|MI',    'RO|BI', 'ΣO|AI|SU' ],  # SUB
	[ 'IO|MI',    'AO|RI',          0 ],  # STA
	[ 'IO|AI',          0,          0 ],  # LDI
	[  'IO|J',          0,          0 ],  # JMP
	[ 'IO|BI',    'ΣO|AI',          0 ],  # ADI, Atm, unofficial instructions
	[ 'IO|BI', 'ΣO|AI|SU',          0 ],  # SBI, Atm, unofficial instructions
	[       0,          0,          0 ],  # xxx
	[       0,          0,          0 ],  # xxx
	[       0,          0,          0 ],  # xxx
	[       0,          0,          0 ],  # xxx
	[       0,          0,          0 ],  # xxx
	[ 'AO|OI',          0,          0 ],  # OUT
	[   'HLT',          0,          0 ],  # HLT
]

fetch = [ 'CO|MI', 'RO|II|CE' ]


# -- Functions ----

def bin2hex( a ):

	h = ''

	if isinstance( a, list ):

		h = int( ''.join( a ), 2 )
		h = hex( h )[2 : ].zfill(2)
	
	elif a == 0:

		h = '00'

	# return h
	return 'x"{}"'.format( h )

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

	unused = [ bin2hex( 0 ) ] * ( 6 - len( microInstructions[0] ) )

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

		ubyts.extend( unused )
		lbyts.extend( unused )

		ubytes.append( ubyts )
		lbytes.append( lbyts )

	return( ubytes, lbytes )


# -- Print output ----

code = getMicroHex()

for b in code[0]:
	print( ', '.join( b ) )
for b in code[1]:
	print( ', '.join( b ) )
