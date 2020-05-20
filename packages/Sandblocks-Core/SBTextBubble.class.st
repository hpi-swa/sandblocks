Class {
	#name : #SBTextBubble,
	#superclass : #SBBlock,
	#instVars : [
		'text',
		'colored'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextBubble >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBTextBubble >> colored [

	^ colored
]

{ #category : #'as yet unclassified' }
SBTextBubble >> colored: aBoolean [

	colored := aBoolean
]

{ #category : #'as yet unclassified' }
SBTextBubble >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBTextBubble >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBTextBubble >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBTextBubble >> drawnColor [

	^ self colored ifTrue: [super drawnColor] ifFalse: [self parentSandblock drawnColor]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> emphasis: aTextEmphasis [

	text emphasis: aTextEmphasis
]

{ #category : #'as yet unclassified' }
SBTextBubble >> font: aFont [

	text font: aFont
]

{ #category : #'as yet unclassified' }
SBTextBubble >> initialize [

	super initialize.
	
	colored := true.
	
	self
		addMorphBack: (text := SBOwnTextMorph new
			when: #contentsChanged send: #triggerEvent: to: self with: #contentsChanged);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBTextBubble >> keyStroke: anEvent [

	text keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBTextBubble >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBTextBubble >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (self containingArtefact ifNil: [SBInputCommand newNonEdit] ifNotNil: [:a | SBInputCommand newFor: a])
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBTextBubble >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textMorph [

	^ text
]
