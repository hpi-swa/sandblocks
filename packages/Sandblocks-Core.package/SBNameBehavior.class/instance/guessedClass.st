as yet unclassified
guessedClass

	^ self block binding ifNotNil: [:b | b value class]