*Sandblocks-Core
asSandblock

	| methodNode class parser source sourceRanges debuggerMap rangeToPC nodeToPC rangeToPCList instructions |
	SBToggledCode
		comment: 'either extract info from source (1st) or use generated result (may include errors, but might be more accurate)'
		active: 1
		do: {
			[
				class := self methodClass.
				parser := class newParser encoderClass: self encoderClass.
				source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
				methodNode := parser parse: source class: class.
				sourceRanges := parser encoder rawSourceRanges.
				debuggerMap := self debuggerMap.
				instructions := InstructionStream on: self.
				rangeToPCList := Array streamContents: [:stream | 
					[instructions atEnd] whileFalse: [
						stream nextPut: (debuggerMap rangeForPC: instructions pc in: self contextIsActiveContext: true) -> instructions pc.
						instructions nextInstruction]].
				rangeToPC := Dictionary new.
				rangeToPCList do: [:assoc | 
					(#(#storeIntoReceiverVariable: #storeIntoTemporaryVariable: #popIntoReceiverVariable: #popIntoTemporaryVariable: #pushClosureCopyNumCopiedValues:numArgs:blockSize: #send:super:numArgs:) includes: (instructions
						 pc: assoc value;
						 nextInstruction) selector) ifTrue: [rangeToPC at: assoc key put: assoc value]].
				nodeToPC := sourceRanges collect: [:range | rangeToPC at: range ifAbsent: [0]].
				nodeToPC keysAndValuesDo: [:node :pc | node pc: pc]].
			[
				methodNode := self methodNode.
				methodNode generate]
		}.
	^ methodNode asSandblock