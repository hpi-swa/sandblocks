Class {
	#name : #SBTextBubble,
	#superclass : #SBBlock,
	#instVars : [
		'text',
		'colored',
		'prefix',
		'bordered',
		'suffix',
		'emphasis',
		'object',
		'textMorphClass'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextBubble class >> multiLine [

	^ self basicNew
		textMorphClass: SBMultilineOwnTextMorph;
		initialize
]

{ #category : #'as yet unclassified' }
SBTextBubble >> absorbsInput: anEvent [

	^ self textMorphClass = SBMultilineOwnTextMorph
		ifTrue: [SBGrammarHandler eventValidForString: anEvent]
		ifFalse: [super absorbsInput: anEvent]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> bordered [

	^ bordered
]

{ #category : #'as yet unclassified' }
SBTextBubble >> bordered: aBoolean [

	bordered := aBoolean
]

{ #category : #'as yet unclassified' }
SBTextBubble >> changeToUnknown [
	<action>

	self sandblockEditor startInput: self at: 0 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBTextBubble >> colorAlpha: aNumber [

	text colorAlpha: aNumber
]

{ #category : #'as yet unclassified' }
SBTextBubble >> colored [

	^ colored
]

{ #category : #'as yet unclassified' }
SBTextBubble >> colored: aBoolean [

	colored := aBoolean.
	self color: Color transparent
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
SBTextBubble >> dismiss [
	<action>
	
	self triggerEvent: #dismiss
]

{ #category : #'as yet unclassified' }
SBTextBubble >> drawnColor [

	^ self colored ifTrue: [super drawnColor] ifFalse: [
		(color = Color transparent and: [self parentSandblock notNil])
			ifTrue: [self parentSandblock drawnColor]
			ifFalse: [color]]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> emphasis [

	^ emphasis ifNil: [TextEmphasis normal]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> emphasis: aTextEmphasis [

	emphasis := aTextEmphasis.
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
	bordered := true.
	
	self
		addMorphBack: (text := self textMorphClass new
			when: #contentsChanged
			send: #triggerEvent:
			to: self
			with: #contentsChanged);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBTextBubble >> keyStroke: anEvent [

	text keyStroke: anEvent.
	self triggerEvent: #keyStroke with: anEvent
]

{ #category : #'as yet unclassified' }
SBTextBubble >> maxWidth: aNumber [

	self currentTextMorph maxWidth: aNumber
]

{ #category : #'as yet unclassified' }
SBTextBubble >> object [

	^ object ifNil: [super object]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> object: anObject [

	object := anObject
]

{ #category : #'as yet unclassified' }
SBTextBubble >> pasteReplace [
	<action>

	self currentTextMorph insertString: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
SBTextBubble >> placeholderText: aString [

	text placeholderText: aString
]

{ #category : #'as yet unclassified' }
SBTextBubble >> prefersNoBorder [

	^ bordered not
]

{ #category : #'as yet unclassified' }
SBTextBubble >> prefix [

	^ prefix
]

{ #category : #'as yet unclassified' }
SBTextBubble >> prefix: aString [

	prefix := aString
]

{ #category : #'as yet unclassified' }
SBTextBubble >> printOn: aStream [

	aStream nextPutAll: 'text bubble'
]

{ #category : #'as yet unclassified' }
SBTextBubble >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBTextBubble >> stopEditing: aCommand [

	super stopEditing: aCommand.
	
	self triggerEvent: #stopEditing
]

{ #category : #'as yet unclassified' }
SBTextBubble >> suffix [

	^ suffix
]

{ #category : #'as yet unclassified' }
SBTextBubble >> suffix: aString [

	suffix := aString
]

{ #category : #'as yet unclassified' }
SBTextBubble >> symbols [

	^ {prefix. suffix}
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textContents [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textMorphClass [

	^ textMorphClass ifNil: [SBOwnTextMorph]
]

{ #category : #'as yet unclassified' }
SBTextBubble >> textMorphClass: aClass [

	textMorphClass := aClass
]

{ #category : #'as yet unclassified' }
SBTextBubble >> wantsInput [

	^ self contents isEmpty
]
