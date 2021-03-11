Extension { #name : #CompiledMethod }

{ #category : #'*Sandblocks-Core' }
CompiledMethod >> asSandblock [

	| methodNode class parser source nodeToRange debuggerMap rangeToPC nodeToPC rangeToPCList instructions |
	SBToggledCode
		comment: 'either extract info from source (1st) or use generated result (may include errors, but might be more accurate)'
		active: 4
		do: {
			[
				class := self methodClass.
				parser := class newParser encoderClass: self encoderClass.
				parser class = Parser ifTrue: [parser := PPParser new encoderClass: self encoderClass].
				
				source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
				methodNode := parser parse: source asString class: class.
				nodeToRange := parser encoder rawSourceRanges.
				debuggerMap := self debuggerMap.
				instructions := InstructionStream on: self.
				rangeToPCList := Array streamContents: [:stream |
					self enumerateInstructions: debuggerMap of: self on: stream].
				
				rangeToPC := Dictionary new.
				rangeToPCList do: [:assoc |
					(#(#storeIntoReceiverVariable: #storeIntoTemporaryVariable: #popIntoReceiverVariable: #popIntoTemporaryVariable: #pushClosureCopyNumCopiedValues:numArgs:blockSize: #pushFullClosure:numCopied: #send:super:numArgs: #methodReturnConstant: #methodReturnReceiver #methodReturnTop #jump:if:) includes: assoc value second) ifTrue: [rangeToPC at: assoc key put: assoc value first]].
				nodeToPC := nodeToRange collect: [:range | rangeToPC at: range ifAbsent: [0]].
				nodeToPC keysAndValuesDo: [:node :pc | node pc: pc]].
			[
				methodNode := self methodNode.
				methodNode generate].
			[methodNode := SBPCMapper new applyMappingFor: self methodNode].
			[
				class := self methodClass.
				parser := Parser new encoderClass: self encoderClass.
				source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
				methodNode := SBPCMapper new
					applyMappingFor: (parser parse: source asString codeWithEmptyLineMarkers class: class)]
		}.
	^ methodNode asSandblock
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
	
	convert do: [self asSandblock]
]
