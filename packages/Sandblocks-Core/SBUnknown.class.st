Class {
	#name : #SBUnknown,
	#superclass : #SBBlock,
	#instVars : [
		'grammarHandler',
		'deleteIfDismissed',
		'hadOwner'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'text input' }
SBUnknown >> acceptCharacter: aCharacter [

	self grammarHandler perform: aCharacter for: self empty: true
]

{ #category : #'text input' }
SBUnknown >> acceptInputEvent: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme.
	" auto-complete unambiguous matches? "
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		self grammarHandler perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'action helpers' }
SBUnknown >> actionProviders [

	^ super actionProviders, {self grammarHandler}
]

{ #category : #accessing }
SBUnknown >> contents [

	^ self currentTextMorph contents
]

{ #category : #accessing }
SBUnknown >> contents: aString [

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor selection contents: editor selection contents, aString allButFirst]
]

{ #category : #accessing }
SBUnknown >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #accessing }
SBUnknown >> deleteIfDismissed [

	^ deleteIfDismissed
]

{ #category : #accessing }
SBUnknown >> deleteIfDismissed: aBoolean [

	deleteIfDismissed := aBoolean
]

{ #category : #drawing }
SBUnknown >> drawInvalidBorderOn: aCanvas [

	" if we have a label do not draw a strong red border "
	self contents
		ifNotEmpty: [aCanvas frameRectangle: self bounds width: 1 * self scalingFactor color: (Color red alpha: 0.7)]
		ifEmpty: [super drawInvalidBorderOn: aCanvas]
]

{ #category : #drawing }
SBUnknown >> drawnColor [

	^ Color transparent
]

{ #category : #accessing }
SBUnknown >> endInput [
	<inputAction>

	self sandblockEditor endInput.
	self deleteIfDismissed ifTrue: [self sandblockEditor do: (SBDeleteCommand new target: self)]
]

{ #category : #accessing }
SBUnknown >> grammarHandler [

	^ grammarHandler
]

{ #category : #accessing }
SBUnknown >> grammarHandler: aHandler [

	grammarHandler := aHandler
]

{ #category : #accessing }
SBUnknown >> initialize [

	super initialize.
	
	self
		addMorphBack: SBOwnTextMorph new;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	
	hadOwner := false.
	deleteIfDismissed := false
]

{ #category : #testing }
SBUnknown >> isExpression [

	^ true
]

{ #category : #testing }
SBUnknown >> isUnknown [

	^ true
]

{ #category : #'text input' }
SBUnknown >> keyStroke: anEvent [

	self acceptCharacter: anEvent keyCharacter
]

{ #category : #accessing }
SBUnknown >> label: aString [

	self currentTextMorph placeholderText: aString
]

{ #category : #layout }
SBUnknown >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self currentTextMorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBUnknown >> lookupAction: aSymbol [
	" first try our leaf class, then the grammar handler, then our base classes "

	self class
		lookupSelector: aSymbol
		upTo: SBUnknown
		ifPresent: [:m | (self isValidAction: m) ifTrue: [^ self]]
		ifAbsent: [].
	(self grammarHandler class lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self grammarHandler]].
	(SBStASTNode superclass lookupSelector: aSymbol) ifNotNil: [:m | (self isValidAction: m) ifTrue: [^ self]].
	^ nil
]

{ #category : #accessing }
SBUnknown >> newNullBlock [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBUnknown >> noteNewOwner: aMorph [
	" we're guessing that, if we changed owners, our label is no longer relevant "

	hadOwner == true ifTrue: [self label: ''].
	hadOwner := true
]

{ #category : #'as yet unclassified' }
SBUnknown >> prefersNoBorder [

	^ self valid
]

{ #category : #printing }
SBUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown'
]

{ #category : #accessing }
SBUnknown >> sourceString [

	^ ''
]

{ #category : #'text input' }
SBUnknown >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self
				contents: '';
				moveCursorTo: 0]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'text input' }
SBUnknown >> stopEditing [

	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #'text input' }
SBUnknown >> stopEditing: aCommand [

	aCommand
		newText: self currentTextMorph contents;
		newMorph: self.
	
	self stopEditing
]

{ #category : #accessing }
SBUnknown >> symbols [

	^ self colorPolicy symbolsForUnknown: self
]

{ #category : #testing }
SBUnknown >> valid [

	^ self isStatement
]

{ #category : #testing }
SBUnknown >> wantsInput [

	^ true
]

{ #category : #accessing }
SBUnknown >> wasDeselected [

	| editor |
	editor := self sandblockEditor.
	
	(self deleteIfDismissed and: [editor notNil]) ifTrue: [ | wasInput previousSelection |
		previousSelection := editor selection.
		wasInput := editor mode = #input.
		self sandblockEditor do: (SBDeleteCommand new target: self).
		
		(previousSelection notNil and: [previousSelection sandblockEditor notNil]) ifTrue: [
			previousSelection select.
			wasInput ifTrue: [editor startInput: previousSelection at: 900000000 replacingContents: false]]]
]

{ #category : #printing }
SBUnknown >> writeSourceOn: aStream [

	self valid ifTrue: [self grammarHandler writeSourceOn: aStream for: self]
]
