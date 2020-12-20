as yet unclassified
guessedClass

	^ (self block containingArtefact typeFor: self)
		ifNil: [
			(self contents size > 3 and: [self contents first = $a]) ifTrue: [ | className |
				className := (self contents second = $n
					ifTrue: [self contents allButFirst: 2]
					ifFalse: [self contents allButFirst]) asSymbol.
				Smalltalk at: className ifAbsent: [nil]]]