Class {
	#name : #SBStateMachineTransition,
	#superclass : #SBConnectorLine,
	#instVars : [
		'conditions'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> addCondition: aBlock [

	conditions addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> checkAutoDelete [

	" ingored "
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> color [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> conditions [

	^ conditions
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> connectAutoDelete: aBlock [

	" ignored "
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> doLayoutIn: aRectangle [

	| directions |
	directions := #(#bottomRight #bottomLeft #topLeft #topRight).
	self evade caseOf: {
		[#none] -> [conditions center: aRectangle center].
		[#left] -> [
			conditions center: ((Bezier3Segment perform: #from:via:and:to: withArguments: self curvePointsForEvade) valueAt: 0.4)].
		[#right] -> [
			conditions center: ((Bezier3Segment perform: #from:via:and:to: withArguments: self curvePointsForEvade) valueAt: 0.6)]
	}.
	super doLayoutIn: aRectangle
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> endPointsDo: aBlock [

	^ super endPointsDo: [:a :b |
		a = b
			ifTrue: [aBlock value: a value: b]
			ifFalse: [ | direction |
				direction := (b - a) normalized * 3.
				aBlock value: a + direction value: b - direction]]
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> handlesMouseDown: anEvent [

	^ (super handlesMouseDown: anEvent) or: [(self morphsAt: anEvent position) size > 1]
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> initialize [

	super initialize.
	
	conditions := SBStateMachineConditionList new useAlgebraLayout.
	
	self addMorphBack: conditions
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> preferredColor [

	^ SBStASTNode preferredColor
]
