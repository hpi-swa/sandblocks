Class {
	#name : #SBProbedValue,
	#superclass : #Object,
	#instVars : [
		'value',
		'frames'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBProbedValue >> contextIdentityHashFor: aMethod [

	^ frames detect: [:frame | frame method = aMethod] ifFound: [:frame | frame contextIdentityHash]
]

{ #category : #'as yet unclassified' }
SBProbedValue >> frames [

	^ frames
]

{ #category : #'as yet unclassified' }
SBProbedValue >> hadMethodOnStack: aMethod [

	^ frames anySatisfy: [:frame | frame method == aMethod]
]

{ #category : #'as yet unclassified' }
SBProbedValue >> hadMethodOnStack: aMethod block: aClosure [

	^ frames anySatisfy: [:frame | frame method = aClosure]
]

{ #category : #'as yet unclassified' }
SBProbedValue >> value [

	^ value
]

{ #category : #'as yet unclassified' }
SBProbedValue >> value: anObject context: aContext [

	value := anObject.
	frames := (aContext stackOfSize: 10) collect: [:frame |
		SBStackFrameIdentifier new context: frame]
]
