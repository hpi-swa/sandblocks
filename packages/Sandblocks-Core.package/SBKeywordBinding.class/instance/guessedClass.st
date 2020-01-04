as yet unclassified
guessedClass

	self contents = 'self' ifTrue: [^ self containingMethod methodClass].
	self contents = 'super' ifTrue: [^ self containingMethod methodClass superclass].
	self contents = 'thisContext' ifTrue: [^ Context].
	self contents = 'nil' ifTrue: [^ UndefinedObject].
	self contents  = 'false' ifTrue: [^ False].
	self contents = 'true' ifTrue: [^ True].
	^ nil