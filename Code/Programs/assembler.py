# ========================================================================================
# 
#  Attribution:
# 
#     Code by www.jk-quantized.com
# 
#  Redistributions and use of this code in source and binary forms must retain
#  the above attribution notice and this condition.
# 
# ========================================================================================


# -- Imports -----------------------------------------

import re
import os


# -- Lookups -----------------------------------------

instructions = [

	'NOP', 'LDA', 'ADD', 'SUB',
	'STA', 'LDI', 'JMP', 'xxx',
	'xxx', 'xxx', 'xxx', 'xxx',
	'xxx', 'xxx', 'OUT', 'HLT'
]


# -- Extraction --------------------------------------


cmdPattern = '''
	^                # from beginning of string
	.*?              # select all characters until
	(?=\/\/|[\r\n])  # reach start of a comment or the string's end
'''
cmdPattern = re.compile( cmdPattern, re.X )

def extractCmd( line ):

	found = re.search( cmdPattern, line )

	if found:

		return found.group(0)

	else:

		return None

def extractCmds( inputFile ):

	commands = []

	with open( inputFile, 'r' ) as input_file:
		
		for line in input_file:

			cmd = extractCmd( line )

			if cmd:

				commands.append( cmd )

	return commands


# -- Translation -------------------------------------

def toBin( x, N ):

	return bin( x )[2:].zfill( N )

def translateCmds( cmdList ):

	commands = []

	for cmd in cmdList:

		cmd = cmd.split( ' ' )

		instruction = cmd[ 0 ]

		immediate = 0

		if len( cmd ) > 1 :

			immediate = int( cmd[ 1 ] )

		instruction_nibble = toBin( instructions.index( instruction ), 4 )
		immediate_nibble = toBin( immediate, 4 )

		commands.append( instruction_nibble + immediate_nibble )

	return commands


# -- Output --------------------------------------

def writeToOutputFile( binCmdList, outputFile ):

	with open( outputFile, 'w' ) as output_file:
		
		for cmd_binary in binCmdList:

			output_file.write( cmd_binary + '\n' )


# -- Run ---------------------------------------------

def asm_to_bin( inputFile, outputFile ):

	cmds_assembly = extractCmds( inputFile )

	cmds_binary = translateCmds( cmds_assembly )

	writeToOutputFile( cmds_binary, outputFile )

	print( 'Done!' )


# Temp
asm_to_bin( 'Source/arithmeticTest.asm', 'Binaries/arithmeticTest.bin' )
