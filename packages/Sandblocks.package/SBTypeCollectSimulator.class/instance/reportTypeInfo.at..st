as yet unclassified
reportTypeInfo: anObject at: aContext

	| location |
"	Transcript showln: {anObject class. aContext. aContext previousPc}."
	location := (SBCodeContext for: aContext) pc: (aContext previousPc"aContext selector numArgs max: 0").
	self assert: ((InstructionStream on: aContext method) pc: location pc; nextInstruction) selector = #send:super:numArgs:.
	editor reportTypeInfo: anObject at: location