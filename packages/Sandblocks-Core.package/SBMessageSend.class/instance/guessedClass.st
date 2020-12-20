as yet unclassified
guessedClass

	^ self containingArtefact ifNotNil: [:a | a typeFor: self]