Class {
	#name : #SBRepresentationAggregate,
	#superclass : #SBBlock,
	#instVars : [
		'count'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationAggregate >> count [

	^ self submorphs first
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregate >> initialize [

	super initialize.
	count := 0.
	self
		changeTableLayout;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		layoutInset: 8;
		cellPositioning: #center;
		addMorphBack: SBBadge new;
		addMorphBack: (SBStNumberWithPrefix new
			value: 5;
			prefix: '#');
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregate >> limit [

	^ self submorphs second value
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregate >> object [

	^ self submorphs third object
]

{ #category : #'as yet unclassified' }
SBRepresentationAggregate >> replace: anObject [

	self addMorph: (anObject anyRepresentationThat: #isToplevelMorph) asElementNumber: 3.
	count := count + 1.
	self count contents: count asString.
	[(self submorphCount - 2) > self limit] whileTrue: [self lastSubmorph delete]
]
