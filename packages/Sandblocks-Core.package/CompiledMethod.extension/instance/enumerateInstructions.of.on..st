*Sandblocks-Core
enumerateInstructions: aDebuggerMap of: aCompiledCode on: aStream

	| instructions |
	instructions := InstructionStream on: aCompiledCode.
	^ [instructions atEnd] whileFalse: [ | instruction pc |
		pc := instructions pc.
		instruction := instructions nextInstruction.
		aStream nextPut: (aDebuggerMap rangeForPC: pc in: aCompiledCode contextIsActiveContext: true) -> {pc. instruction selector}.
		instruction selector = #pushFullClosure:numCopied: ifTrue: [
			self enumerateInstructions: aDebuggerMap of: instruction arguments first on: aStream]]