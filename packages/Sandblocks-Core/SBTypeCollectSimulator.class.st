Class {
	#name : #SBTypeCollectSimulator,
	#superclass : #InstructionClient,
	#instVars : [
		'methodMap',
		'currentContext',
		'topContext'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> blockReturnConstant: value [

"	self reportTypeInfo: value at: currentContext."
	^ currentContext blockReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> blockReturnTop [

"	self reportTypeInfo: currentContext top at: currentContext."
	^ currentContext blockReturnTop
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> callPrimitive: pimIndex [
	"SqueakV3PlusClosures:	239 11101111	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 NewsqueakV4:				249 11111001	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 SistaV1:					248 11111000 iiiiiiii mjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjj * 256)
									m=1 means inlined primitive, no hard return after execution."
	^ currentContext callPrimitive: pimIndex
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> directedSuperSend: selector numArgs: numArgs [
	"Send Message Above Specific Class With Selector, selector, bytecode.
	 Start the lookup above the class that is the value of the association on
	 top of stack. The arguments  of the message are found in the top numArgs
	 stack locations beneath the association, and the receiver just below them."
	^ currentContext directedSuperSend: selector numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> doDup [
	"Duplicate Top Of Stack bytecode."
	^ currentContext doDup
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> doPop [
	"Remove Top Of Stack bytecode."
	^ currentContext doPop
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> jump: offset [
	"Unconditional Jump bytecode."
	^ currentContext jump: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> jump: offset if: condition [ 
	"Conditional Jump bytecode."
	^ currentContext jump: offset if: condition
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> methodMap [

	^ methodMap
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> methodMap: aDictionary [

	methodMap := aDictionary
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> methodReturnConstant: value [ 

	self reportTypeInfo: value at: currentContext methodReturnContext sender.
	^ currentContext methodReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> methodReturnReceiver [

	self reportTypeInfo: currentContext receiver at: currentContext methodReturnContext sender.
	^ currentContext methodReturnReceiver
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> methodReturnTop [

	self reportTypeInfo: currentContext top at: currentContext methodReturnContext sender.
	^ currentContext methodReturnTop
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> popIntoLiteralVariable: anAssociation [ 
	"Remove Top Of Stack And Store Into Literal Variable bytecode."
	^ currentContext popIntoLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> popIntoReceiverVariable: offset [
	"Remove Top Of Stack And Store Into Instance Variable bytecode."
	^ currentContext popIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Remove Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> popIntoTemporaryVariable: offset [ 
	"Remove Top Of Stack And Store Into Temporary Variable bytecode."
	^ currentContext popIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushActiveContext [
	"Push Active Context On Top Of Its Own Stack bytecode."
	^ currentContext pushActiveContext
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [
	"Push Closure bytecode."
	^ currentContext pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushConsArrayWithElements: numElements [
	"Push Cons Array of size numElements popping numElements items from the stack into the array bytecode."
	^ currentContext pushConsArrayWithElements: numElements
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushConstant: value [
	"Push Constant, value, on Top Of Stack bytecode."
	^ currentContext pushConstant: value
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushFullClosure: aCompiledBlock numCopied: numCopied [
	"Push Full Closure bytecode."
	^ currentContext pushFullClosure: aCompiledBlock numCopied: numCopied
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushLiteralVariable: anAssociation [
	"Push Contents Of anAssociation On Top Of Stack bytecode."
	^ currentContext pushLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushNewArrayOfSize: numElements [ 
	"Push New Array of size numElements bytecode."
	^ currentContext pushNewArrayOfSize: numElements
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushReceiver [
	"Push Active Context's Receiver on Top Of Stack bytecode."
	^ currentContext pushReceiver
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushReceiverVariable: offset [
	"Push Contents Of the Receiver's Instance Variable Whose Index 
	is the argument, offset, On Top Of Stack bytecode."
	^ currentContext pushReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Push Contents at Offset in Temp Vector bytecode."
	^ currentContext pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> pushTemporaryVariable: offset [

	"Transcript showln: {currentContext tempAt: offset + 1. currentContext endPC}."
	
	^ currentContext pushTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> reportTypeInfo: anObject at: aContext [

	"location := (SBCodeContext for: aContext) pc: (aContext previousPc)."
	"self assert: ((InstructionStream on: aContext method) pc: pc; nextInstruction) selector = #send:super:numArgs:."
	methodMap at: aContext method sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (method blockForPC: aContext previousPc)]
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> reportTypeInfo: anObject at: aContext findNode: aBlock [

	"editor reportTypeInfo: anObject at: aContext findNode: aBlock"
	methodMap at: aContext method sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (aBlock value: method)]
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> send: selector super: supered numArgs: numArgs [

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: (currentContext at: currentContext stackPtr - numArgs)].
	
	(lookupClass lookupSelector: selector) ifNotNil: [:method |
		" report argument types "
		(currentContext stackPtr - numArgs + 1 to: currentContext stackPtr) withIndexDo: [:stackIndex :index |
			SBCodeContext class: lookupClass selector: selector ifValid: [:location |
				self
					reportTypeInfo: (currentContext at: stackIndex)
					at: location
					findNode: [:methodMorph | methodMorph arguments at: index]]].
		
		" report primitives "
		method primitive > 0 ifTrue: [ | ret |
			" perform:withArguments "
			method primitive = 84 ifTrue: [ | actualSelector actualReceiver actualClass |
				actualReceiver := currentContext at: currentContext stackPtr - 2.
				actualSelector := currentContext at: currentContext stackPtr - 1.
				actualClass := ((currentContext objectClass: actualReceiver) lookupSelector: actualSelector) methodClass.
				(currentContext at: currentContext stackPtr) withIndexDo: [:argument :index |
					self
						reportTypeInfo: argument
						at: (SBCodeContext class: actualClass selector: actualSelector)
						findNode: [:methodMorph | methodMorph arguments at: index]].].
			self flag: #todo. " other perform: variants "
			
			ret := currentContext send: selector super: supered numArgs: numArgs.
			(currentContext isDead not and: [currentContext stackPtr > 0]) ifTrue: [self reportTypeInfo: currentContext top at: currentContext].
			
			" value:... block closure invocation "
			((method primitive between: 201 and: 209) or: [method primitive between: 221 and: 222]) ifTrue: [
				ret arguments withIndexDo: [:argument :index |
					self
						reportTypeInfo: argument
						at: (SBCodeContext for: ret)
						findNode: [:methodMorph | (methodMorph blockForPC: ret previousPc) ifNotNil: [:block | block bindings at: index]]]].
			
			^ ret]].
	
	^ currentContext send: (selector = #halt ifTrue: [#yourself] ifFalse: [selector]) super: supered numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> simulate: aBlock [

	| simulationContext |
	aBlock hasMethodReturn
		ifTrue: [self error: 'simulation of blocks with ^ can run loose']. "could probably be solved by guarding method returns"
	simulationContext := thisContext.
	currentContext := topContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext == simulationContext] whileFalse: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ simulationContext pop
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> storeIntoLiteralVariable: anAssociation [ 
	"Store Top Of Stack Into Literal Variable Of Method bytecode."
	^ currentContext storeIntoLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> storeIntoReceiverVariable: offset [ 
	"Store Top Of Stack Into Instance Variable Of Method bytecode."
	^ currentContext storeIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Store Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> storeIntoTemporaryVariable: offset [ 
	"Store Top Of Stack Into Temporary Variable Of Method bytecode."
	^ currentContext storeIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBTypeCollectSimulator >> trapIfNotInstanceOf: behaviorOrArrayOfBehavior [
	"If the top of stack is not an instance of either the argument, or, if the argument is an Array,
	  any of the elements of the argument, send the class trap message to the current context."
	^ currentContext trapIfNotInstanceOf: behaviorOrArrayOfBehavior
]
