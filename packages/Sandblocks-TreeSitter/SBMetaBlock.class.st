Class {
	#name : #SBMetaBlock,
	#superclass : #SBBlock,
	#instVars : [
		'factory',
		'symbols',
		'textFieldPattern',
		'textField',
		'grammarRule',
		'slots',
		'slot'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlock >> canDeleteChild: aBlock [

	slots slotOf: aBlock in: self do: [:slot :morphs |
		slot := self slotOf: aBlock.
		slot required ifFalse: [^ true].
		^ slot multiple and: [morphs size > 1]].
	self assert: false
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> contents [

	^ super contents ifNil: [self firstSubmorph contents]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> currentTextMorph [

	^ textField
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> cursorPositionsDo: aBlock [

	aBlock value: (SBCursorSelect new block: self).
	slots cursorPositionsWith: self submorphs in: self do: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> extent: aPoint [

	super extent: (aPoint max: self spaceForSymbols sum + 2 @ self minimumHeight)
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> factory [

	^ factory
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> factory: aFactory grammarRule: anObject slot: aSlot [

	factory := aFactory.
	grammarRule := anObject.
	slots := factory buildSlotsFor: anObject.
	slot := aSlot
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> grammarRule [

	^ grammarRule
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> grammarRule: aRule [

	grammarRule := aRule.
	slots := factory buildSlotsFor: aRule
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> initialize [

	symbols := #(nil nil).
	
	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		symbols: #(nil nil);
		cellPositioning: #center
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> keyStroke: evt [

	super keyStroke: evt.
	
	(evt keyCharacter isPrintable and: [self valid not]) ifTrue: [
		self deleteBeforeCursor.
		factory
			rulesMatching: (self parentSandblock slotOf: self) objectInterface
			containing: self objectInterface
			forPrefix: evt keyCharacter asString
			do: [:rule :myField :operatorField | | block |
				block := SBMetaBlock new.
				^ self sandblockEditor do: (SBWrapCommand new
					inner: self;
					outer: block;
					wrap: [:outer :inner |
						factory
							build: rule type
							in: block
							withValues: ({myField -> self. operatorField -> evt keyCharacter asString} as: Dictionary)])]]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> objectInterface [

	^ self shouldNotImplement
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> printOn: aStream [

	| objectInterface |
	objectInterface := slot objectInterface.
	objectInterface ifNil: [^ aStream nextPutAll: (self contents ifNil: ['<>'])].
	
	aStream nextPutAll: (objectInterface isString
		ifTrue: [objectInterface]
		ifFalse: [objectInterface joinSeparatedBy: ','])
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slot [

	^ slot
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slotOf: aMorph [

	^ slots slotOf: aMorph in: self do: [:slot :morphs | slot]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slots [

	^ slots
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> symbols [

	^ symbols
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> symbols: aCollection [

	symbols := aCollection.
	self extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> textFieldPattern [

	^ textFieldPattern
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> textFieldPattern: aString [

	textFieldPattern := aString.
	self addMorphBack: (textField := SBOwnTextMorph new vResizing: #shrinkWrap)
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> valid [

	^ textFieldPattern
		ifNotNil: [
			(textFieldPattern isKindOf: RxMatcher)
				ifTrue: [textFieldPattern matches: textField contents]
				ifFalse: [
					textFieldPattern isString
						ifTrue: [textField contents matchesRegex: textFieldPattern]
						ifFalse: [factory token: textFieldPattern matches: self contents]]]
		ifNil: [true]
]
