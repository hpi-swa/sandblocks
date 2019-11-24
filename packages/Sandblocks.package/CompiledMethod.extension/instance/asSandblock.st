*Sandblocks
asSandblock

	| methodNode class parser source sourceRanges debuggerMap rangeToPC nodeToPC rangeToPCList |
	true ifTrue: [
			class := self methodClass.
			parser := class newParser encoderClass: self encoderClass.
			source := self getSourceFor: (self selector ifNil: [self defaultSelector]) in: class.
			methodNode := parser parse: source class: class.
			sourceRanges := parser encoder rawSourceRanges.
			debuggerMap := self debuggerMap.
			
			rangeToPCList := (self initialPC to: self endPC) collect: [:pc | (debuggerMap rangeForPC: pc in: self contextIsActiveContext: true) -> pc].
			rangeToPC := Dictionary new.
			rangeToPCList do: [:assoc | (rangeToPC includesKey: assoc key) ifFalse: [rangeToPC at: assoc key put: assoc value]].
			
			nodeToPC := sourceRanges collect: [:range | rangeToPC at: range ifAbsent: [0]].
			nodeToPC keysAndValuesDo: [:node :pc | node pc: pc]]
		ifFalse: [
			methodNode := self methodNode.
			methodNode generate].
	
	^ methodNode asSandblock