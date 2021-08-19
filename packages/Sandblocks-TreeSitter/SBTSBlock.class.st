Class {
	#name : #SBTSBlock,
	#superclass : #SBBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSBlock >> buildPartial: anOptions with: aString [

	^ SBTSBlock new addMorphBack: (self firstSubmorph buildPartial: anOptions with: aString)
]

{ #category : #'as yet unclassified' }
SBTSBlock >> canDeleteChild: aBlock [

	^ aBlock owner canDeleteChild: aBlock
]

{ #category : #'as yet unclassified' }
SBTSBlock >> currentTextMorph [

	^ self firstSubmorph currentTextMorph
]

{ #category : #'as yet unclassified' }
SBTSBlock >> cursorPositionsDo: aBlock [

	aBlock value: (SBCursorSelect new block: self).
	self submorphsDo: [:m | m cursorPositionsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBTSBlock >> deleteCommandFor: aBlock [

	^ (aBlock owner deleteTargetFor: aBlock)
		ifNotNil: [:target | SBDeleteCommand new target: target]
		ifNil: [
			aBlock newNullBlock ifNotNil: [:nullBlock |
				SBReplaceCommand new
					target: aBlock;
					replacer: nullBlock]]
]

{ #category : #'as yet unclassified' }
SBTSBlock >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellPositioning: #center
]

{ #category : #'as yet unclassified' }
SBTSBlock >> isUnambiguous [
	" if we don't have submorphs yet, this is being called recursively during block construction "

	^ self hasSubmorphs ifTrue: [self firstSubmorph isUnambiguous] ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBTSBlock >> printOn: aStream [

	aStream nextPutAll: self firstSubmorph title
]

{ #category : #'as yet unclassified' }
SBTSBlock >> printTitleOn: aStream [

	self firstSubmorph printTitleOn: aStream
]

{ #category : #'as yet unclassified' }
SBTSBlock >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ self firstSubmorph triggersFor: aString matchFullToken: aBoolean options: anOptions
]
