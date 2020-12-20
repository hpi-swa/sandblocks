as yet unclassified
testWrapInCascadeMessageParts

	| block selection editor |
	block := '[5 yourself. 5 parse: 2]' parseAsSandblock.
	selection := block statements first.
	editor := self editorFor: block.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second messageParts first.
	editor select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection.
	self assert: block statements first messages first receiver isNil.
	self assert: block statements first messages second receiver isNil