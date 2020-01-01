as yet unclassified
reportTypeInfo: anObject at: aContext

	| location |
	location := (SBCodeContext for: aContext) pc: (aContext previousPc).
	self assert: ((InstructionStream on: aContext method) pc: location pc; nextInstruction) selector = #send:super:numArgs:.
	editor reportTypeInfo: anObject at: location