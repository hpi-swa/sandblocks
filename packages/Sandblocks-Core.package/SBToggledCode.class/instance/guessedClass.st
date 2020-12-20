as yet unclassified
guessedClass

	^ self activeBlock ifNotNil: [:block | block isBlockBody ifTrue: [block lastSubmorph guessedClass] ifFalse: [block guessedClass]]