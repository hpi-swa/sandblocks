Class {
	#name : #SBMetaBlock,
	#superclass : #SBBlock,
	#instVars : [
		'factory',
		'objectInterface',
		'symbols',
		'textFieldPattern',
		'textField',
		'grammarRule',
		'slots'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlock >> canDeleteChild: aBlock [

	slots slotOf: aBlock in: self do: [:slot :morphs |
		slot := self slotOf: aBlock.
		slot required ifFalse: [^ true].
		^ slot multiple and: [morphs size > 1]]
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
SBMetaBlock >> cursorPositionsForRule: anObject stream: aStream do: aBlock [

	| repeat |
	(factory unpackTypes includes: anObject type) ifTrue: [^ self cursorPositionsForRule: anObject content stream: aStream do: aBlock].
	
	repeat := [
		self insertCursorNear: aStream peek before: true do: aBlock.
		[aStream atEnd not and: [aStream peek objectInterface = anObject content name]] whileTrue: [ | next |
			next := aStream next.
			aBlock value: (SBCursorSelect new block: next).
			aBlock value: (SBCursorInsert new
				command: (SBRelInsertCommand new
					near: next
					before: false
					in: self
					morph: (factory unknownFor: anObject content name));
				before: false;
				adjacent: next;
				container: self)]].
	
	anObject type caseOf: {
		['STRING'] -> [aStream next].
		['PATTERN'] -> [
			aBlock value: (SBCursorText new
				block: self;
				currentCommand: self startInputCommand)].
		['SYMBOL'] -> [aStream next cursorPositionsDo: aBlock].
		['REPEAT1'] -> [repeat value].
		['REPEAT'] -> [repeat value].
		['CHOICE'] -> [
			(anObject members size = 2 and: [anObject members contains: [:m | m type = 'BLANK']])
				ifTrue: [
					(aStream atEnd not and: [aStream peek isSandblock and: [aStream peek objectInterface = anObject members first name]])
						ifTrue: [aStream next cursorPositionsDo: aBlock]
						ifFalse: [
							aBlock value: (SBCursorInsert new
								command: (SBRelInsertCommand new
									near: aStream last
									before: false
									in: self
									morph: (factory unknownFor: anObject members first name));
								before: false;
								adjacent: aStream last;
								container: self)]]
				ifFalse: [self assert: false]].
		['SEQ'] -> [anObject members do: [:m | self cursorPositionsForRule: m stream: aStream do: aBlock]]}
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> defaultRepeatableChildInterface: aSymbol [

	defaultRepeatableChildInterface := aSymbol
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
		symbols: #(nil nil)
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

	^ objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> objectInterface: anInterface [

	objectInterface := anInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> objectInterfaceOf: aSubmorph [

	| index |
	index := self submorphIndexOf: aSubmorph.
	^ (slots at: index) objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> printOn: aStream [

	aStream nextPutAll: objectInterface
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slotOf: aMorph [

	^ slots slotOf: aMorph in: self do: [:slot :morphs | slot]
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
	self addMorphBack: (textField := SBOwnTextMorph new)
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
