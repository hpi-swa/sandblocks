Class {
	#name : #SBLabel,
	#superclass : #SBSubstitution,
	#instVars : [
		'headingLevel',
		'text'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLabel class >> matches: aBlock [

	^ aBlock receiver isBinding and: [aBlock receiver contents = self name] and: [aBlock selector = 'text:']
]

{ #category : #'as yet unclassified' }
SBLabel class >> newFrom: aBlock [

	^ self new textBlock: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBLabel class >> text: aBlock [

	" marker "
]

{ #category : #'as yet unclassified' }
SBLabel >> changeHeadingLevel: aNumber [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #headingLevel;
		value: aNumber)
]

{ #category : #'as yet unclassified' }
SBLabel >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBLabel >> codeActions [

	^ {
		SBCodeAction
			labeled: 'Change to regular text' for: self do: [:node | node changeHeadingLevel: 0].
		SBCodeAction
			labeled: 'Change to small heading' for: self do: [:node | node changeHeadingLevel: 1].
		SBCodeAction
			labeled: 'Change to medium heading' for: self do: [:node | node changeHeadingLevel: 2].
		SBCodeAction
			labeled: 'Change to large heading' for: self do: [:node | node changeHeadingLevel: 3].
	}, super codeActions
]

{ #category : #'as yet unclassified' }
SBLabel >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBLabel >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBLabel >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBLabel >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBLabel >> headingLevel [

	^ headingLevel
]

{ #category : #'as yet unclassified' }
SBLabel >> headingLevel: aNumber [

	headingLevel := aNumber.
	text font: (TextStyle default fontAt: TextStyle default defaultFontIndex + headingLevel)
]

{ #category : #'as yet unclassified' }
SBLabel >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (text := SBMultilineOwnTextMorph new emphasis: TextEmphasis italic);
		headingLevel: 0
]

{ #category : #'as yet unclassified' }
SBLabel >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBLabel >> keyStroke: anEvent [

	text keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBLabel >> label: aString [

	| headingStream |
	headingLevel := 0.
	headingStream := aString readStream.
	[headingStream next = $#] whileTrue: [headingLevel := headingLevel + 1].
	
	self contents: (aString allButFirst: headingLevel).
	self headingLevel: headingLevel
]

{ #category : #'as yet unclassified' }
SBLabel >> printOn: aStream [

	aStream nextPutAll: 'label ', (self contents truncateWithElipsisTo: 20)
]

{ #category : #'as yet unclassified' }
SBLabel >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBLabel >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing
]

{ #category : #'as yet unclassified' }
SBLabel >> symbols [

	^ self colorPolicy symbolsForComment: self
]

{ #category : #'as yet unclassified' }
SBLabel >> textBlock: aBlock [

	self label: (Compiler evaluate: aBlock sourceString) value
]

{ #category : #'as yet unclassified' }
SBLabel >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBLabel >> writeSourceOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' text: ['.
	
	((String new: headingLevel withAll: $#), text contents) storeOn: aStream.
	
	aStream nextPutAll: '])'
]
