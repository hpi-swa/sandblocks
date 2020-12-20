as yet unclassified
replace: anObject

	anObject isNumber ifTrue: [self reportValue: anObject].
	anObject isCollection ifTrue: [
		data clear.
		anObject do: [:val | data add: val].
		self changed]