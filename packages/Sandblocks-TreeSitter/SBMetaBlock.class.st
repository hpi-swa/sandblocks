Class {
	#name : #SBMetaBlock,
	#superclass : #SBBlock,
	#instVars : [
		'factory',
		'symbols',
		'textFieldPattern',
		'textField',
		'grammarRule',
		'slot',
		'parentSlot'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlock >> canDeleteChild: aBlock [

	self slotOf: aBlock do: [:slot :morphs |
		slot required ifFalse: [^ true].
		^ slot multiple and: [morphs size > 1]].
	self assert: false
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> contents [

	^ super contents ifNil: [self firstSubmorph isTextMorph ifTrue: [self firstSubmorph contents] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> currentTextMorph [

	^ textField
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> cursorPositionsDo: aBlock [

	| buildInsert stream previousMorph |
	aBlock value: (SBCursorSelect new block: self).
	
	buildInsert := [:adjacent :before :slot |
		aBlock value: (SBCursorInsert new
			command: (SBMetaRelInsertCommand new
				near: adjacent
				before: before
				in: self
				factory: self factory
				slot: slot);
			before: before;
			adjacent: adjacent;
			container: self)].
	
	stream := self submorphs readStream.
	previousMorph := nil.
	self slot morphsRepeatedIn: stream factory: self factory do: [:slot :morphs |
		slot printString = '((''->''),(type),optional)' ifTrue: [SBToggledCode comment: '' active: 0 do: {[self halt]}].
		morphs do: [:morph |
			slot multiple ifTrue: [buildInsert value: morph value: true value: slot].
			SBToggledCode comment: '' active: 1 do: {[morph cursorPositionsDo: aBlock]}.
			slot multiple ifTrue: [buildInsert value: morph value: false value: slot].
			morph isTextMorph ifTrue: [
				morph containingSandblock startInputCommand ifNotNil: [:command |
					aBlock value: (SBCursorText new
						block: morph containingSandblock;
						currentCommand: command)]]].
		Transcript showln: {slot. morphs}.
		morphs ifNotEmpty: [previousMorph := morphs last] ifEmpty: [
			previousMorph
				ifNotNil: [:m | buildInsert value: m value: false value: slot]
				ifNil: [buildInsert value: nil value: true value: slot]]]
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
SBMetaBlock >> factory: aFactory parentSlot: aSlot [

	factory := aFactory.
	parentSlot := aSlot.
	slot := aSlot isBlockSlot  ifTrue: [factory slotsFor: aSlot type] ifFalse: [aSlot]
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> grammarRule [

	^ grammarRule
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
SBMetaBlock >> isMetaBlock [

	^ true
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
SBMetaBlock >> parentSlot [

	^ parentSlot
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> printOn: aStream [

	parentSlot printOn: aStream
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slot [

	^ slot
]

{ #category : #'as yet unclassified' }
SBMetaBlock >> slotOf: aMorph do: aBlock [

	^ slot
		morphsRepeatedIn: self submorphs readStream
		factory: self factory
		do: [:slot :morphs |
			Transcript showln: {slot. morphs}.
			(morphs includes: aMorph) ifTrue: [^ aBlock value: slot value: morphs]]
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
