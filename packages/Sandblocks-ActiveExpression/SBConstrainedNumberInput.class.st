"
A SBConstrainedNumberInput allows picking a number by scrubbing on the morph. It will display its max value next to the current value.
"
Class {
	#name : #SBConstrainedNumberInput,
	#superclass : #SBNumberInput,
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #accessing }
SBConstrainedNumberInput >> max: aNumber [

	super max: aNumber.
	self contents: self value asString, ' /', self max asString
]

{ #category : #accessing }
SBConstrainedNumberInput >> value: aNumber [

	super value: aNumber.
	self contents: self contents, ' /', self max asString
]
