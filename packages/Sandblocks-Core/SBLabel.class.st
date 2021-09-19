Class {
	#name : #SBLabel,
	#superclass : #SBBlock,
	#instVars : [
		'headingLevel',
		'text',
		'delimiter',
		'grammarHandler'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLabel class >> text: aString [
	" marker "
]

{ #category : #'as yet unclassified' }
SBLabel >> absorbsInput: anEvent [

	^ SBGrammarHandler eventValidForString: anEvent
]

{ #category : #'as yet unclassified' }
SBLabel >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBLabel >> changeHeadingLevel: aNumber [

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #headingLevel;
		value: aNumber)
]

{ #category : #'as yet unclassified' }
SBLabel >> changeToLargeHeading [
	<action>

	self changeHeadingLevel: 3
]

{ #category : #'as yet unclassified' }
SBLabel >> changeToMediumHeading [
	<action>

	self changeHeadingLevel: 2
]

{ #category : #'as yet unclassified' }
SBLabel >> changeToRegularText [
	<action>

	self changeHeadingLevel: 0
]

{ #category : #'as yet unclassified' }
SBLabel >> changeToSmallHeading [
	<action>

	self changeHeadingLevel: 1
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
SBLabel >> delimiter: aCollection [

	delimiter := aCollection
]

{ #category : #'as yet unclassified' }
SBLabel >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBLabel >> grammarHandler [

	^ grammarHandler ifNil: [super grammarHandler]
]

{ #category : #'as yet unclassified' }
SBLabel >> grammarHandler: aHandler [

	grammarHandler := aHandler
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
		layoutInset: 0;
		addMorphBack: (text := SBMultilineOwnTextMorph new emphasis: TextEmphasis italic);
		headingLevel: 0
]

{ #category : #'as yet unclassified' }
SBLabel >> isExpression [

	^ false
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
SBLabel >> lookupAction: aSymbol [
	" first try our leaf class, then the grammar handler, then our base classes "

	self class lookupSelector: aSymbol upTo: SBStASTNode ifPresent: [:m | (self isValidAction: m) ifTrue: [^ self]] ifAbsent: [].
	
	(self grammarHandler class lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self grammarHandler]].
	
	(SBStASTNode superclass lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self]].
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBLabel >> pasteString [
	<inputAction>
	
	self currentTextMorph insertString: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
SBLabel >> preferredColorIn: aColorPolicy [

	^ aColorPolicy defaultLight
]

{ #category : #'as yet unclassified' }
SBLabel >> printOn: aStream [

	aStream nextPutAll: 'label ', (self contents truncateWithElipsisTo: 20)
]

{ #category : #'as yet unclassified' }
SBLabel >> startInputAt: aNumber replacingContents: aBoolean [

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
SBLabel >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing
]

{ #category : #'as yet unclassified' }
SBLabel >> symbols [

	^ delimiter ifNil: [self colorPolicy symbolsForComment: self]
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
SBLabel >> useAsString [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStString new contents: self contents))
]

{ #category : #'as yet unclassified' }
SBLabel >> wantsInput [

	^ self contents isEmpty
]

{ #category : #'as yet unclassified' }
SBLabel >> writeSourceOn: aStream [

	(delimiter notNil and: [delimiter last isNil])
		ifTrue: [
			aStream nextPutAll: (String new: headingLevel withAll: $#).
			text contents lines
				do: [:line | aStream nextPutAll: delimiter first, line]
				separatedBy: [aStream cr]]
		ifFalse: [
			aStream nextPutAll: (delimiter ifNotNil: [delimiter first] ifNil: ['"']).
			aStream nextPutAll: (String new: headingLevel withAll: $#), text contents].
	(delimiter ifNotNil: [delimiter second] ifNil: ['"']) ifNotNil: [:s | aStream nextPutAll: s]
]

{ #category : #'as yet unclassified' }
SBLabel >> writeSourceOn: aStream indent: aNumber [

	self writeSourceOn: aStream
]
