as yet unclassified
reportTypeInfo: anObject at: aContext

	"location := (SBCodeContext for: aContext) pc: (aContext previousPc)."
	"self assert: ((InstructionStream on: aContext method) pc: pc; nextInstruction) selector = #send:super:numArgs:."
	methodMap at: aContext method sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (method blockForPC: aContext previousPc)]