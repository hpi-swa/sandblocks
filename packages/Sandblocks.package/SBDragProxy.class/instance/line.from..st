as yet unclassified
line: aMorph from: aNodeSocket

	line := aMorph.
	socket := aNodeSocket.
	
	aMorph end: self.
	
	type := aNodeSocket type caseOf: {[#flowIn] -> [#flowOut]. [#flowOut] -> [#flowIn]. [#input] -> [#output]. [#output] -> [#input]}