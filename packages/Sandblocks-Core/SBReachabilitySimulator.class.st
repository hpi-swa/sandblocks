Class {
	#name : #SBReachabilitySimulator,
	#superclass : #SBSimulator,
	#instVars : [
		'store'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> jump: offset if: condition [ 
	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super jump: offset if: condition
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> methodReturnConstant: value [ 

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super methodReturnConstant: value
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> methodReturnReceiver [

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super methodReturnReceiver
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> methodReturnTop [

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super methodReturnTop
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> popIntoLiteralVariable: offset [ 

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super popIntoLiteralVariable: offset
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> popIntoReceiverVariable: offset [ 

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super popIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> popIntoTemporaryVariable: offset [ 

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super popIntoTemporaryVariable: offset
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> send: selector super: supered numArgs: numArgs [

	store report: currentContext method homeMethod pc: currentContext previousPc.
	^ super send: selector super: supered numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBReachabilitySimulator >> store: aColorPolicy [

	store := aColorPolicy
]
