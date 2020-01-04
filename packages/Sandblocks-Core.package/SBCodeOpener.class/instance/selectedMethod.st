as yet unclassified
selectedMethod

	| class |
	class := (Smalltalk at: self selectedClass).
	showingClassSide ifTrue: [class := class class].
	^  class >> (self methods at: self selectedMethodIndex)