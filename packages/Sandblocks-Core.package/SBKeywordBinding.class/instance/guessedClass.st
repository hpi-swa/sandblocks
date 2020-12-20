as yet unclassified
guessedClass

	self contents = 'self' ifTrue: [^ self block containingArtefact relatedClass].
	self contents = 'super' ifTrue: [^ self block containingArtefact relatedClass superclass].
	self contents = 'thisContext' ifTrue: [^ Context].
	self contents = 'nil' ifTrue: [^ UndefinedObject].
	self contents  = 'false' ifTrue: [^ False].
	self contents = 'true' ifTrue: [^ True].
	^ nil