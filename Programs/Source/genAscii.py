s = "Greetings!\nIt's great to be awake!\n"

for c in s:

	n = ord( c )
	print( '// {} -> {}'.format( c, n ) )
	
	if n < 16:

		print( 'LDI', n )
		print( 'OUT' )

	else:

		d,m = divmod( n, 15 )
		print('LDI', 15 )

		if d > 1:

			for i in range( 1, d ):

				print( 'ADI', 15 )

			print( 'ADI', m )
			print( 'OUT' )

	print()
