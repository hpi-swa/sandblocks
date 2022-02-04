Class {
	#name : #SBColor,
	#superclass : #SBStSubstitution,
	#instVars : [
		'indicator',
		'previousColor'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #suggestions }
SBColor class >> instanceSuggestion [

	^ [self new colorContents: (Color r: 1 g: 0.0 b: 0.0)]
]

{ #category : #testing }
SBColor class >> matches: aMessage [

	SBExample
		self: [SBColor]
		args: [{(SBStMessageSend new receiver: (SBStName contents: 'Color') selector: #orange)}]
		label: 'matching'.
	SBExample
		self: [SBColor]
		args: [{(SBStMessageSend new receiver: (SBStName contents: 'Color') selector: #fromUser)}]
		label: 'non matching'.
	
	(super matches: aMessage) ifFalse: [^ false].
	
	((aMessage receiver satisfies: #(notNil isBinding)) and: [#('Color' 'ECSColor') includes: aMessage receiver contents]) ifFalse: [^ false].
	^ aMessage selector asSymbol isUnary
		ifTrue: [
			(Color respondsTo: aMessage selector asSymbol)
				and: [#('named colors' 'named colors - crayons') includes: (Color class organization categoryOfElement: aMessage selector asSymbol)]]
		ifFalse: [(aMessage selector = 'r:g:b:' or: [aMessage selector = 'r:g:b:a:' or: [aMessage selector = 'fromString:']]) and: [aMessage arguments allSatisfy: #isLiteralBlock]]
]

{ #category : #'instance creation' }
SBColor class >> newFor: aMessage [

	^ self new colorContents: aMessage evaluate
]

{ #category : #'as yet unclassified' }
SBColor >> colorContents [

	^ indicator color
]

{ #category : #'as yet unclassified' }
SBColor >> colorContents: aColor [

	indicator color: aColor
]

{ #category : #'as yet unclassified' }
SBColor >> colorContentsUpdate: aColor [

	self colorContents: aColor.
	self batchedChangeStep
]

{ #category : #'as yet unclassified' }
SBColor >> doubleClick: anEvent [

	previousColor := self colorContents.
	
	(NewColorPickerMorph on: self originalColor: indicator color setColorSelector: #colorContentsUpdate:)
		openInWorld;
		bottomLeft: self positionInWorld - (30 @ 30);
		when: #closed send: #saveColor to: self
]

{ #category : #'as yet unclassified' }
SBColor >> guessedClass [

	^ Color
]

{ #category : #'as yet unclassified' }
SBColor >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 1;
		addMorphBack: (indicator := Morph new
			extent: 16 asPoint * self scalingFactor;
			color: Color red)
]

{ #category : #'as yet unclassified' }
SBColor >> printOn: aStream [

	indicator color printOn: aStream
]

{ #category : #'as yet unclassified' }
SBColor >> saveColor [

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #colorContents;
		value: self colorContents;
		oldValue: previousColor)
]

{ #category : #'as yet unclassified' }
SBColor >> writeSourceOn: aStream [

	aStream nextPut: $(.
	indicator color storeOn: aStream.
	aStream nextPut: $)
]
