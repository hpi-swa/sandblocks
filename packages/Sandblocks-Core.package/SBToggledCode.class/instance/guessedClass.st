as yet unclassified
guessedClass

	^ self activeBlock ifNotNil: [:block | block lastSubmorph guessedClass]