"
A SBMarble marks a single invocation of an active expression. It will keep its value, subject (owner of the active expression) and side effects and will try to highlight the subject when hovered. It can also appear as a synchronous event as triggered by SBActiveExpressionSyncEvent, in which case it will be rectangular rather than circular.
"
Class {
	#name : #SBMarble,
	#superclass : #CircleMorph,
	#instVars : [
		'subject',
		'subjectIndicator',
		'sideEffects',
		'isSync'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #'as yet unclassified' }
SBMarble class >> marbleSize [

	^ 10 asPoint withScalingFactor
]

{ #category : #'halos and balloon help' }
SBMarble >> balloonHelpDelayTime [

	^ 0
]

{ #category : #drawing }
SBMarble >> drawOn: aCanvas [

	self isSync
		ifTrue: [aCanvas fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle]
		ifFalse: [aCanvas fillOval: self bounds fillStyle: self fillStyle borderWidth: self borderWidth borderColor: self borderColor]
]

{ #category : #examples }
SBMarble >> example [

	SBMorphExample
		setUp: [SBMarble new]
		cases: {
			(SBMorphExampleCase
				name: 'test'
				caseBlock: [:m :world | m subject: ((Morph new openInWorld: world) position: world position); value: 5])
		}
		extent: 100 @ 100
]

{ #category : #'event handling' }
SBMarble >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #constants }
SBMarble >> indicatorBorderWidth [

	^ 4 withScalingFactor
]

{ #category : #'initialize-release' }
SBMarble >> initialize [

	super initialize.
	
	self extent: self class marbleSize.
	self isSync: false
]

{ #category : #accessing }
SBMarble >> isSync [

	^ isSync
]

{ #category : #accessing }
SBMarble >> isSync: aBoolean [

	isSync := aBoolean
]

{ #category : #'event handling' }
SBMarble >> mouseEnter: anEvent [

	subjectIndicator ifNotNil: #delete.
	subjectIndicator := Morph new
		addMorphBack: (Morph new
			color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			borderStyle: (BorderStyle width: self indicatorBorderWidth color: Color red);
			extent: subject extent + (self indicatorBorderWidth * 2);
			yourself);
		addMorphBack: (Morph new
			addMorph: (StringMorph new contents: self balloonText; yourself);
			vResizing: #shrinkWrap;
			hResizing: #shrinkWrap;
			color: Color white;
			layoutInset: 4 withScalingFactor;
			borderStyle: (BorderStyle width: 2 color: Color black);
			yourself);
		bounds: (subject boundsInWorld outsetBy: self indicatorBorderWidth);
		openInWorld;
		color: Color transparent;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		yourself
]

{ #category : #'event handling' }
SBMarble >> mouseLeave: anEvent [

	subjectIndicator ifNotNil: #delete
]

{ #category : #accessing }
SBMarble >> sideEffects [

	^ sideEffects
]

{ #category : #accessing }
SBMarble >> sideEffects: aCollection [

	sideEffects := aCollection
]

{ #category : #accessing }
SBMarble >> subject [

	^ subject
]

{ #category : #accessing }
SBMarble >> subject: anObject [

	subject := anObject.
	self color: subject sandblockColor
]

{ #category : #accessing }
SBMarble >> value: anotherObject [

	self balloonText: anotherObject asString
]
