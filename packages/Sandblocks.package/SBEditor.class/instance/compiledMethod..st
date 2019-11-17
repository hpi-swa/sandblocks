actions
compiledMethod: aMethod

	| methodNode class parser source sourceRanges debuggerMap rangeToPC nodeToPC rangeToPCList |
	"methodNode := aMethod methodNode""Parser new parse: aMethod getSource class: aMethod methodClass".
	
	self flag: #todo. "fallback to decompile?"
	compiledMethod := aMethod.
	
	true ifTrue: [
			class := aMethod methodClass.
			parser := class newParser encoderClass: aMethod encoderClass.
			source := aMethod getSourceFor: (aMethod selector ifNil: [aMethod defaultSelector]) in: class.
			methodNode := parser parse: source class: class.
			sourceRanges := parser encoder rawSourceRanges.
			debuggerMap := aMethod debuggerMap.
	
			rangeToPCList := (aMethod initialPC to: aMethod endPC) collect: [:pc | (debuggerMap rangeForPC: pc in: aMethod contextIsActiveContext: true) -> pc].
			rangeToPC := Dictionary new.
			rangeToPCList do: [:assoc | (rangeToPC includesKey: assoc key) ifFalse: [rangeToPC at: assoc key put: assoc value]].
	
			nodeToPC := sourceRanges collect: [:range | rangeToPC at: range ifAbsent: [0]].
			nodeToPC keysAndValuesDo: [:node :pc | node pc: pc]]
		ifFalse: [
			methodNode := aMethod methodNode.
			methodNode generate].
	
	self method: methodNode asSandblock