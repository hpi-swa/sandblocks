as yet unclassified
reportTypeInfo: anObject at: aContext

	| location |
	(aContext previousPc = 135 and: [aContext selector = #drawOnSimple]) ifTrue: [self halt].
	location := (SBCodeContext for: aContext) pc: (aContext previousPc).
	self assert: ((InstructionStream on: aContext method) pc: location pc; nextInstruction) selector = #send:super:numArgs:.
	editor reportTypeInfo: anObject at: location