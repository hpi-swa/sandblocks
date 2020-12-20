as yet unclassified
arguments

	^ Array streamContents: [:stream | self argumentsDo: [:a | stream nextPut: a]]