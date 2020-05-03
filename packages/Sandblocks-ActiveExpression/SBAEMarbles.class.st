"
A SBAEMarbles displays a list of SBMarbles. When a marble is clicked, it will request for its active expression to be put into focus, for example by a SBAEInvocations morph. 
"
Class {
	#name : #SBAEMarbles,
	#superclass : #Morph,
	#instVars : [
		'lastTickTime'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #'as yet unclassified' }
SBAEMarbles class >> matches: anObject [

	^ anObject class = SynchronousActiveExpression
]

{ #category : #accessing }
SBAEMarbles >> addMarble: aMorph value: anObject expression: anExpression [

	self updateTickDividers.
	self addMorphBack: (SBMarble new
		subject: aMorph;
		value: anObject;
		on: #click send: #selectExpression:event:marble: to: self withValue: anExpression;
		yourself)
]

{ #category : #accessing }
SBAEMarbles >> addSyncEventFrom: anObject with: aValue [

	self updateTickDividers.
	self addMorphBack: (SBMarble new
		subject: anObject;
		isSync: true;
		value: aValue;
		on: #click send: #selectSubject:event:subject: to: self withValue: anObject;
		yourself)
]

{ #category : #'example callbacks' }
SBAEMarbles >> exampleFinished: aSBExample [ 

]

{ #category : #'example callbacks' }
SBAEMarbles >> exampleStarting: anExample [

	self removeAllMorphs.
	self extent: 0 @ 0
]

{ #category : #initialization }
SBAEMarbles >> initialize [

	super initialize.
	
	self
		 color: Color transparent;
		 changeTableLayout;
		 hResizing: #spaceFill;
		 vResizing: #shrinkWrap;
		 listDirection: #leftToRight;
		 cellPositioning: #topLeft;
		 wrapDirection: #leftToRight;
		 minimumWidth: 200 withScalingFactor;
		 extent: 0 @ 0;
		 cellGap: 2 withScalingFactor
]

{ #category : #constants }
SBAEMarbles >> marbleSize [

	^ 10 asPoint withScalingFactor
]

{ #category : #callbacks }
SBAEMarbles >> selectExpression: anExpression event: anEvent marble: aMorph [

	self triggerEvent: #selectExpression with: anExpression
]

{ #category : #callbacks }
SBAEMarbles >> selectSubject: anObject event: anEvent subject: aMorph [

	self triggerEvent: #selectSubject with: anObject
]

{ #category : #callbacks }
SBAEMarbles >> updateTickDividers [

	| tickTime |
	tickTime := WorldState lastCycleTime.
	(lastTickTime ~= tickTime and: [self hasSubmorphs])
		ifTrue: [
			self addMorphBack: (Morph new
				 color: Color lightGray;
				 extent: 2 @ SBMarble marbleSize y;
				 yourself)].
	lastTickTime := tickTime
]
