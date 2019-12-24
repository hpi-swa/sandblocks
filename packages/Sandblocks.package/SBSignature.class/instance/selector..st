as yet unclassified
selector: aString

	| currentNum newNum arguments |
	currentNum := self numArgs.
	newNum := aString numArgs.
	
	arguments := (self arguments copyFrom: 1 to: (newNum min: currentNum)), (Array streamContents: [:s |
		currentNum + 1 to: newNum do: [:i | s nextPut: SBUnknown new]]).
	
	self selector: aString arguments: arguments