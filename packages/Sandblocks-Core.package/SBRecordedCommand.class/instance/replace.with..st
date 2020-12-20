action
replace: aMorph with: anotherMorph

	undo add: [anotherMorph replaceBy: aMorph].
	aMorph replaceBy: anotherMorph.
	self added: anotherMorph