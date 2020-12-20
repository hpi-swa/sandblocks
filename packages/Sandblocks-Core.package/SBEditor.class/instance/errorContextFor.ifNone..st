shortcuts
errorContextFor: anArtefact ifNone: anExceptionBlock

	^ errors focusedArtefact = anArtefact ifTrue: [errors focusedContext] ifFalse: [anExceptionBlock value]