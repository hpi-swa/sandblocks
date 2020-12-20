actions
debugExpression
	<action>
	
	| artefact cue context process |
	artefact := self containingArtefact.
	context := self sandblockEditor errors focusedArtefact = artefact ifTrue: [self sandblockEditor errors focusedContext] ifFalse: [nil].
	cue := self compilationCueWith: artefact for: context.
	
	process := Process
		forMethod: (Compiler new compileCue: cue noPattern: true ifFail: nil) generateWithTempNames
		receiver: (context ifNotNil: #receiver).
	
	self sandblockEditor reportError: nil process: process