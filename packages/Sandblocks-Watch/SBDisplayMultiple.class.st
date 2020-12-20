Class {
	#name : #SBDisplayMultiple,
	#superclass : #Morph,
	#instVars : [
		'count',
		'countInput',
		'dark'
	],
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayMultiple class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> count: aNumber [

	count := aNumber.
	countInput value: aNumber.
	
	self submorphs allButFirstDo: [:morph | self removeMorph: morph].
	count timesRepeat: [self addMorphBack: SBDisplayPrint new]
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> dark: aBoolean [

	dark := aBoolean.
	self submorphs allButFirstDo: [:morph | morph dark: aBoolean]
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> exampleFinished: aSBExample [ 

]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> initialize [

	super initialize.
	
	dark := false.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		color: Color transparent;
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			cellInset: (TextStyle defaultFont height / 2) floor;
			addMorphBack: (countInput := SBNumberInput new color: Color white; min: 1; onChange: [:num | self count: num]);
			addMorphBack: (SBIcon iconBar_chart large; on: #click send: #promptChangeDisplay to: self));
		count: 5
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> promptChangeDisplay [

	| choices index |
	choices := (SBWatchView watchTypes copyWithout: SBDisplayMultiple)" select: [:display |  isNil or: [display matches: lastValue]]".
	
	index := UIManager default chooseFrom: choices.
	index < 1 ifTrue: [^ self].
	
	self submorphs allButFirstDo: [:m| m delete].
	count timesRepeat: [self addMorphBack: ((choices at: index) new)]
]

{ #category : #'as yet unclassified' }
SBDisplayMultiple >> reportValue: anObject [

	| new |
	new := self lastSubmorph.
	new reportValue: anObject.
	self addMorph: new asElementNumber: 2
]
