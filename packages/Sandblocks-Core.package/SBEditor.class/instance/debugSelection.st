actions
debugSelection

	| source artefact cue context process |
	source := self selection.
	artefact := source containingArtefact.
	context := errors focusedArtefact = artefact ifTrue: [errors focusedContext] ifFalse: [nil].
	cue := source compilationCueWith: artefact for: context.
	
	process := Process
		forMethod: (Compiler new compileCue: cue noPattern: true ifFail: nil) generateWithTempNames
		receiver: (context ifNotNil: #receiver).
	
	self reportError: process suspendedContext process: process