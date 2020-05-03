Class {
	#name : #SBArraySourceNode,
	#superclass : #SBNewNode,
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBArraySourceNode >> autoPlace [

	self autoPlaceFlow
]

{ #category : #'as yet unclassified' }
SBArraySourceNode >> autoPlaceFlow [

	| current y x |
	y := self top.
	x := self left.
	current := self.
	[current] whileNotNil: [
		current center: x @ y; fullBounds.
		current autoPlaceInputs.
		y := y + current height + 30.
		current := current flowOutSocket connectedLink ifNotNil: #targetNode]
]

{ #category : #'as yet unclassified' }
SBArraySourceNode >> hasFlowIn [

	^ false
]

{ #category : #'as yet unclassified' }
SBArraySourceNode >> hasFlowOut [

	^ true
]

{ #category : #'as yet unclassified' }
SBArraySourceNode >> outputs [

	^ #('[]')
]
