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
		type: self type;
		template: self template
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
SBTSUnknown >> factory: aFactory [

	factory := aFactory
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
SBTSUnknown >> keyStroke: anEvent [

	| choices |
	self currentTextMorph keyStroke: anEvent.
	
	choices := SBTSRuleExplore new
		explore: template value
		for: self contents
		startSymbol: type.
	
	choices size > 1 ifTrue: [ | shortest |
		shortest := choices detectMin: [:choice | choice lengthOfLeftMostPath].
		choices removeAllSuchThat: [:choice |
			choice ~= shortest and: [
				choice leftMostRule
					firstDifferingUpBlocksWith: shortest leftMostRule
					do: [:a :b | a firstSubmorph isKindOf: SBInlineBlockSymbol]
					ifNone: [false]]]].
	
	choices size = 1 ifTrue: [
		self sandblockEditor do: (SBReplaceCommand new
			target: self owner;
			replacer: choices first).
		choices first containingSandblock startInputAtEnd]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown '.
	template value printTitleOn: aStream
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
SBTSUnknown >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> type: aString [

	type := aString
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
