Class {
	#name : #SBTSUnknown,
	#superclass : #SBUnknown,
	#instVars : [
		'type',
		'factory',
		'template'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSUnknown >> buildCopy [

	^ self class new
		type: self type factory: self factory;
		template: self template
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> childrenForQueryDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> cursorPositionsDo: aBlock [

	aBlock value: (SBCursorSelect new block: self).
	self startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: self;
			currentCommand: command)]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> factory [

	^ factory ifNil: [self owner isInlineBlock ifTrue: [self owner factory] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> firstDifferingBlocksWith: aMorph do: aBlock [

	(self template value hasSameStructureAs: aMorph template value) ifFalse: [^ aBlock value: self value: aMorph].
	^ nil
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> grammarHandler [

	^ self factory ifNotNil: #grammarHandler
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> hasSameContentsAs: aBlock [

	^ aBlock class = self class and: [aBlock template value hasSameStructureAs: self template value]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> hasSameStructureAs: aBlock [

	^ aBlock class = self class and: [self type = aBlock type]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> inline [

	^ false
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> instantiate [

	^ self
]

{ #category : #testing }
SBTSUnknown >> isBuilt [

	^ true
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> isTemplate [

	^ false
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	self tryInterpretInput: self contents
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> lengthOfLeftMostPath [

	^ 1
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> numAlternativesIn: anOption [

	^ 1
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown '.
	template value printTitleOn: aStream
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> takeStreamFrom: anOption [

	^ false
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> template [

	^ template
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> template: aBlock [

	template := aBlock
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> tryInterpretInput: aString [

	| selected replacer |
	selected := SBTSBlockChooseDialog new
		do: [:query |
			SBTSRuleExplore new
				explore: template value withNested: nil nestedBefore: false for: query startSymbol: type;
				deduplicate]
		query: aString.
	selected ifNil: [^ self].
	
	replacer := type
		ifNotNil: [SBInlineBlockSymbol new type: type factory: self factory block: selected]
		ifNil: [selected].
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: replacer).
	
	SBToggledCode
		comment: ''
		active: 0
		do: {[(replacer firstBlock ifNil: [replacer containingSandblock]) inputContainedUnknown]}.
	SBToggledCode comment: '' active: 1 do: {
		[
			(replacer firstBlock ifNil: [replacer containingSandblock]) select.
			3 timesRepeat: [replacer sandblockEditor performForSelection: #moveCursorSmaller]].
		[
			(replacer startInputCommand
				ifNotNil: [replacer]
				ifNil: [replacer nextBlockThat: [:m | m startInputCommand notNil]])
				ifNotNil: [:m | ((m hasOwner: replacer) or: [m = replacer]) ifTrue: [replacer sandblockEditor startInput: m at: 900000000 replacingContents: false]]
				ifNil: [replacer firstBlock ifNotNil: #select]]}
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> type: aString factory: aFactory [

	type := aString.
	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> unbuiltChildrenIn: anOption [

	^ #()
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> valid [

	^ self isStatement and: [self contents isEmpty]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> veryDeepCopyWith: deepCopier [

	| f copy t |
	f := factory.
	t := template.
	factory := nil.
	template := nil.
	copy := super veryDeepCopyWith: deepCopier.
	factory := f.
	template := t.
	copy factory: f.
	copy template: t.
	^ copy
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> writeMetaSourceOn: aStream [

	aStream nextPutAll: ' '
]
