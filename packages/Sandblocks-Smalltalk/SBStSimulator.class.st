Class {
	#name : #SBStSimulator,
	#superclass : #InstructionClient,
	#instVars : [
		'methodMap',
		'currentContext'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStSimulator >> blockReturnConstant: value [

"	self reportTypeInfo: value at: currentContext."
	^ currentContext blockReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBStSimulator >> blockReturnTop [

"	self reportTypeInfo: currentContext top at: currentContext."
	^ currentContext blockReturnTop
]

{ #category : #'as yet unclassified' }
SBStSimulator >> callPrimitive: pimIndex [
	"SqueakV3PlusClosures:	239 11101111	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 NewsqueakV4:				249 11111001	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 SistaV1:					248 11111000 iiiiiiii mjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjj * 256)
									m=1 means inlined primitive, no hard return after execution."
	^ currentContext callPrimitive: pimIndex
]

{ #category : #'as yet unclassified' }
SBStSimulator >> directedSuperSend: selector numArgs: numArgs [
	"Send Message Above Specific Class With Selector, selector, bytecode.
	 Start the lookup above the class that is the value of the association on
	 top of stack. The arguments  of the message are found in the top numArgs
	 stack locations beneath the association, and the receiver just below them."
	^ currentContext directedSuperSend: selector numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBStSimulator >> doDup [
	"Duplicate Top Of Stack bytecode."
	^ currentContext doDup
]

{ #category : #'as yet unclassified' }
SBStSimulator >> doPop [
	"Remove Top Of Stack bytecode."
	^ currentContext doPop
]

{ #category : #'as yet unclassified' }
SBStSimulator >> jump: offset [
	"Unconditional Jump bytecode."
	^ currentContext jump: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> jump: offset if: condition [ 
	"Conditional Jump bytecode."
	^ currentContext jump: offset if: condition
]

{ #category : #'as yet unclassified' }
SBStSimulator >> methodReturnConstant: value [ 

	^ currentContext methodReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBStSimulator >> methodReturnReceiver [

	^ currentContext methodReturnReceiver
]

{ #category : #'as yet unclassified' }
SBStSimulator >> methodReturnTop [

	^ currentContext methodReturnTop
]

{ #category : #'as yet unclassified' }
SBStSimulator >> popIntoLiteralVariable: anAssociation [ 
	"Remove Top Of Stack And Store Into Literal Variable bytecode."
	^ currentContext popIntoLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBStSimulator >> popIntoReceiverVariable: offset [
	"Remove Top Of Stack And Store Into Instance Variable bytecode."
	^ currentContext popIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Remove Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBStSimulator >> popIntoTemporaryVariable: offset [ 
	"Remove Top Of Stack And Store Into Temporary Variable bytecode."
	^ currentContext popIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushActiveContext [
	"Push Active Context On Top Of Its Own Stack bytecode."
	^ currentContext pushActiveContext
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [
	"Push Closure bytecode."
	^ currentContext pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushConsArrayWithElements: numElements [
	"Push Cons Array of size numElements popping numElements items from the stack into the array bytecode."
	^ currentContext pushConsArrayWithElements: numElements
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushConstant: value [
	"Push Constant, value, on Top Of Stack bytecode."
	^ currentContext pushConstant: value
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushFullClosure: aCompiledBlock numCopied: numCopied [
	"Push Full Closure bytecode."
	^ currentContext pushFullClosure: aCompiledBlock numCopied: numCopied
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushLiteralVariable: anAssociation [
	"Push Contents Of anAssociation On Top Of Stack bytecode."
	^ currentContext pushLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushNewArrayOfSize: numElements [ 
	"Push New Array of size numElements bytecode."
	^ currentContext pushNewArrayOfSize: numElements
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushReceiver [
	"Push Active Context's Receiver on Top Of Stack bytecode."
	^ currentContext pushReceiver
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushReceiverVariable: offset [
	"Push Contents Of the Receiver's Instance Variable Whose Index 
	is the argument, offset, On Top Of Stack bytecode."
	^ currentContext pushReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Push Contents at Offset in Temp Vector bytecode."
	^ currentContext pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBStSimulator >> pushTemporaryVariable: offset [

	^ currentContext pushTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> send: selector super: supered numArgs: numArgs [

	^ currentContext send: selector super: supered numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBStSimulator >> simulate: aBlock [
	
	| simulationContext |
	aBlock hasMethodReturn ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	simulationContext := thisContext.
	currentContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]
]

{ #category : #'as yet unclassified' }
SBStSimulator >> simulateContext: aContext untilReached: anotherContext [

	currentContext := aContext."
	currentContext pushArgs: Array new from: simulationContext."
	[currentContext == anotherContext] whileFalse: [
		currentContext := currentContext interpretNextInstructionFor: self].
	^ currentContext pop
]

{ #category : #'as yet unclassified' }
SBStSimulator >> storeIntoLiteralVariable: anAssociation [ 
	"Store Top Of Stack Into Literal Variable Of Method bytecode."
	^ currentContext storeIntoLiteralVariable: anAssociation
]

{ #category : #'as yet unclassified' }
SBStSimulator >> storeIntoReceiverVariable: offset [ 
	"Store Top Of Stack Into Instance Variable Of Method bytecode."
	^ currentContext storeIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Store Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBStSimulator >> storeIntoTemporaryVariable: offset [ 
	"Store Top Of Stack Into Temporary Variable Of Method bytecode."
	^ currentContext storeIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBStSimulator >> trapIfNotInstanceOf: behaviorOrArrayOfBehavior [
	"If the top of stack is not an instance of either the argument, or, if the argument is an Array,
	  any of the elements of the argument, send the class trap message to the current context."
	^ currentContext trapIfNotInstanceOf: behaviorOrArrayOfBehavior
]
