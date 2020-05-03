Extension { #name : #CompiledCode }

{ #category : #'*Sandblocks-ActiveExpression' }
CompiledCode >> pcOfReceiverAssignmentBefore: thePC [

	| pc byte encoderClass lastAssignmentPC |
	thePC > self endPC ifTrue: [^self endPC].
	self flag: #fixme. " does not support sista "
	
	lastAssignmentPC := 0.
	pc := self initialPC.
	encoderClass := self encoderClass.
	[pc < thePC] whileTrue: [
		byte := self at: pc.
		" pop into receiver or store into receiver "
		(byte = 16r67 or: [byte = 16r81 and: [(self at: pc + 1) = 16r7]]) ifTrue: [lastAssignmentPC := pc].
		 pc := pc + (encoderClass bytecodeSize: byte)].
	^ lastAssignmentPC
]
