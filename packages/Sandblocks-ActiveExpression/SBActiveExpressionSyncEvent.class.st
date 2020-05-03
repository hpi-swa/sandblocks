"
A SBActiveExpressionSyncEvent wraps an expression and reports its execution to any SBAEMarble's currently onscreen with the color of the object in which it is executed. It helps the user to determine execution order between the synchronous statements and the asynchronous invocations of the active expressions.
"
Class {
	#name : #SBActiveExpressionSyncEvent,
	#superclass : #SBSubstitution,
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #'as yet unclassified' }
SBActiveExpressionSyncEvent class >> after: anObject [

	| subject |
	subject := thisContext sender receiver.
	self flag: #performance. " we assume that this operation happens only occurs rarely, since the user would likely be overloaded by the amount of informations otherwise "
	SBAEMarbles allInstancesDo: [:marbles |
		marbles isInWorld ifTrue: [
			marbles addSyncEventFrom: subject with: anObject]].
	^ anObject
]

{ #category : #'as yet unclassified' }
SBActiveExpressionSyncEvent class >> matches: aBlock [

	^ aBlock receiver isName and: [aBlock receiver contents = self name and: [aBlock selector = #after:]]
]

{ #category : #'as yet unclassified' }
SBActiveExpressionSyncEvent class >> newFrom: aBlock [

	^ self new expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBActiveExpressionSyncEvent class >> suggestion [

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: (SBActiveExpressionSyncEvent new expression: SBUnknown new))]
]

{ #category : #accessing }
SBActiveExpressionSyncEvent >> childSandblocksDo: aBlock [

	self submorphCount > 1 ifTrue: [aBlock value: self expression]
]

{ #category : #colors }
SBActiveExpressionSyncEvent >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #accessing }
SBActiveExpressionSyncEvent >> expression [

	^ self lastSubmorph
]

{ #category : #accessing }
SBActiveExpressionSyncEvent >> expression: aBlock [

	self addMorphBack: aBlock
]

{ #category : #suggestions }
SBActiveExpressionSyncEvent >> guessedClass [

	^ self expression guessedClass
]

{ #category : #initialization }
SBActiveExpressionSyncEvent >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 6 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		cellPositioning: #center;
		addMorphBack: SBIcon iconExclamation
]

{ #category : #testing }
SBActiveExpressionSyncEvent >> isExpression [

	^ true
]

{ #category : #printing }
SBActiveExpressionSyncEvent >> printOn: aStream [

	aStream nextPutAll: 'marker around '.
	self expression printOn: aStream
]

{ #category : #printing }
SBActiveExpressionSyncEvent >> writeSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' after: '.
	self expression writeSourceOn: aStream.
	aStream nextPut: $)
]
