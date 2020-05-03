Class {
	#name : #SBToggledCode,
	#superclass : #SBSubstitution,
	#instVars : [
		'comment'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBToggledCode class >> comment: aString active: aNumber do: aCollection [

	^ aNumber > 0 ifTrue: [(aCollection at: aNumber) value] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBToggledCode class >> matches: aBlock [

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBToggledCode'] and: [aBlock selector = 'comment:active:do:']
]

{ #category : #'as yet unclassified' }
SBToggledCode class >> newFrom: aBlock [

	^ self new
		comment: aBlock arguments first contents
		active: aBlock arguments second parsedContents
		do: aBlock arguments third childSandblocks
]

{ #category : #'as yet unclassified' }
SBToggledCode >> activeBlock [

	| index |
	index := self activeIndex.
	^ index > 0 ifTrue: [(self submorphs at: index + 1) lastSubmorph] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> activeIndex [

	self submorphs allButFirst withIndexDo: [:row :index | row firstSubmorph value ifTrue: [^ index]].
	^ 0
]

{ #category : #'as yet unclassified' }
SBToggledCode >> addedMorph: aMorph [

	self updateSelected
]

{ #category : #'as yet unclassified' }
SBToggledCode >> block [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBToggledCode >> buildRowFor: aBlock active: aBoolean [

	| row |
	row := SBRow new.
	row
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBCheckbox new
			when: #toggled
				evaluate: [
					self
						deselectAllBut: (self submorphIndexOf: row) - 1;
						updateSelected];
			value: aBoolean;
			yourself);
		addMorphBack: (aBlock
			setProperty: #previousBlockColor
			toValue: (aBlock valueOfProperty: #sandblockBlockColor ifAbsent: [Color random])).
	^ row
]

{ #category : #'as yet unclassified' }
SBToggledCode >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph.
	self submorphs allButFirstDo: [:b | b submorphsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> color [

	^ self parentSandblock color
]

{ #category : #'as yet unclassified' }
SBToggledCode >> comment: aString active: aNumber do: aCollection [

	comment contents: aString.
	"previousBlockColor := aBlock valueOfProperty: #sandblockBlockColor."
	aCollection withIndexDo: [:block :index |
		self addMorphBack: (self buildRowFor: block active: index = aNumber)].
	self updateSelected
]

{ #category : #'as yet unclassified' }
SBToggledCode >> deleteCommandFor: aBlock [

	^ aBlock = self firstSubmorph
		ifTrue: [
			(SBMutatePropertyCommand newFor: self containingArtefact)
				target: self firstSubmorph;
				selector: #contents;
				value: '']
		ifFalse: [
			(SBDeleteCommand newFor: self containingArtefact)
				target: aBlock owner]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> deselectAllBut: aNumber [

	self submorphs allButFirst withIndexDo: [:row :rowIndex |
		rowIndex ~= aNumber ifTrue: [
			row firstSubmorph value: false.
			row lastSubmorph setProperty: #sandblockBlockColor toValue: Color white; changed]]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBToggledCode >> guessedClass [

	^ self activeBlock ifNotNil: [:block | block lastSubmorph guessedClass]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		layoutInset: 2 withScalingFactor;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (comment := SBTextBubble new layoutInset: (6 @ 2) withScalingFactor; colored: false)
]

{ #category : #'as yet unclassified' }
SBToggledCode >> insertCommandRequest: anAfterBoolean near: aBlock [

	| block index |
	index := (self submorphIndexOf: aBlock owner) ifNil: [2] ifNotNil: [:i | i   + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	block := SBBlockBody empty.
	^ (SBInsertCommand newFor: self containingArtefact)
		index: index;
		container: self;
		morph: (self buildRowFor: block active: false);
		select: block statements first;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBToggledCode >> isWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBToggledCode >> prefix [

	^ '"  '
]

{ #category : #'as yet unclassified' }
SBToggledCode >> printOn: aStream [

	aStream nextPutAll: 'toggled code'.
]

{ #category : #'as yet unclassified' }
SBToggledCode >> updateSelected [

	| index |
	index := self activeIndex.
	
	self deselectAllBut: index.
	
	index > 0 ifTrue: [ | block |
		block := (self submorphs at: index + 1) lastSubmorph.
		block
			setProperty: #sandblockBlockColor toValue: (block valueOfProperty: #previousBlockColor ifAbsent: [Color random]);
			changed]
]

{ #category : #'as yet unclassified' }
SBToggledCode >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBToggledCode comment: '.
	comment contents storeOn: aStream.
	aStream nextPutAll: ' active: '.
	self activeIndex storeOn: aStream.
	aStream nextPutAll: ' do: {'.
	self submorphs allButFirst do: [:row | row lastSubmorph writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
	aStream nextPutAll: '})'
]
