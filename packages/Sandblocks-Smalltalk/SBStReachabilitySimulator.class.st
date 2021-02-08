Class {
	#name : #SBStReachabilitySimulator,
	#superclass : #SBStSimulator,
	#instVars : [
		'store'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> jump: offset if: condition [ 
	store report: currentContext method pc: currentContext previousPc.
	^ super jump: offset if: condition
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> methodReturnConstant: value [ 

	store report: currentContext method pc: currentContext previousPc.
	^ super methodReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> methodReturnReceiver [

	store report: currentContext method pc: currentContext previousPc.
	^ super methodReturnReceiver
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> methodReturnTop [

	store report: currentContext method pc: currentContext previousPc.
	^ super methodReturnTop
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> popIntoLiteralVariable: offset [ 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoLiteralVariable: offset
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> popIntoReceiverVariable: offset [ 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> popIntoTemporaryVariable: offset [ 

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [

	store report: currentContext method pc: currentContext previousPc.
	^ super pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> pushFullClosure: aCompiledBlock numCopied: numCopied [

	store report: currentContext method pc: currentContext previousPc.
	^ super pushFullClosure: aCompiledBlock numCopied: numCopied
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> send: selector super: supered numArgs: numArgs [

	store report: currentContext method pc: currentContext previousPc.
	^ super send: selector super: supered numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBStReachabilitySimulator >> store: aColorPolicy [

	store := aColorPolicy
]
