"
A SBActiveExpression is a simple projection for active expressions. It displays an icons rather than the constructor call.
"
Class {
	#name : #SBActiveExpression,
	#superclass : #SBSubstitution,
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #'as yet unclassified' }
SBActiveExpression class >> matches: aBlock [

	^ aBlock receiver isBinding
		and: [(#('ActiveExpression' 'SynchronousActiveExpression' 'SBSynchronousActiveExpression' 'ManualActiveExpression') includes: aBlock receiver contents)
		and: [aBlock selector = 'on:']]
]

{ #category : #'as yet unclassified' }
SBActiveExpression class >> newFrom: aBubble [

	^ self new block: aBubble arguments first
]

{ #category : #accessing }
SBActiveExpression >> block [

	^ self lastSubmorph
]

{ #category : #accessing }
SBActiveExpression >> block: aBlock [

	self addMorphBack: aBlock
]

{ #category : #accessing }
SBActiveExpression >> childSandblocksDo: aBlock [

	aBlock value: self block
]

{ #category : #initialization }
SBActiveExpression >> initialize [

	super initialize.
	
	self
		layoutInset: 2 withScalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (SBIcon iconExternal_link color: Color black)
]

{ #category : #printing }
SBActiveExpression >> printOn: aStream [

	aStream nextPutAll: 'active expression'
]

{ #category : #printing }
SBActiveExpression >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBSynchronousActiveExpression on: '.
	self block writeSourceOn: aStream.
	aStream nextPut: $)
]
