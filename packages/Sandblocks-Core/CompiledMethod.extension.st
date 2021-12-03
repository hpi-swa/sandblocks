Extension { #name : #CompiledMethod }

{ #category : #'*Sandblocks-Core' }
CompiledMethod >> asSandblock [

	| methodNode class source |
	class := self methodClass.
	source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
	methodNode := SBPCMapper new buildNodeMapFor: source string in: class.
	^ methodNode accept: SBStMethodToBlockWithSubs new
]

{ #category : #'*Sandblocks-Core' }
CompiledMethod >> asSandblockWithoutSubstitution [

	| methodNode class source |
	class := self methodClass.
	source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
	methodNode := SBPCMapper new buildNodeMapFor: source string in: class.
	^ methodNode accept: SBStMethodToBlocks new
]

{ #category : #'*Sandblocks-Core' }
CompiledMethod >> enumerateInstructions: aDebuggerMap of: aCompiledCode on: aStream [

	| instructions |
	instructions := InstructionStream on: aCompiledCode.
	^ [instructions atEnd] whileFalse: [ | instruction pc |
		pc := instructions pc.
		instruction := instructions nextInstruction.
		aStream nextPut: (aDebuggerMap rangeForPC: pc in: aCompiledCode contextIsActiveContext: true) -> {pc. instruction selector}.
		instruction selector = #pushFullClosure:numCopied: ifTrue: [
			self enumerateInstructions: aDebuggerMap of: instruction arguments first on: aStream]]
]

{ #category : #'*Sandblocks-Core' }
CompiledMethod >> open: convert [
	<convert>
	<convertPriority: 10>
	
	convert do: [self asSandblock]
]
