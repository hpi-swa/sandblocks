Class {
	#name : #SBUnknown,
	#superclass : #SBBlock,
	#instVars : [
		'grammarHandler',
		'deleteIfDismissed'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUnknown >> acceptCharacter: aCharacter [

	self grammarHandler perform: aCharacter for: self empty: true
]

{ #category : #'as yet unclassified' }
SBUnknown >> acceptInputEvent: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		SBScmGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBUnknown >> contents [

	^ self currentTextMorph contents
]

{ #category : #accessing }
SBUnknown >> contents: aString [

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor currentInput contents: editor currentInput contents, aString allButFirst]
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

{ #category : #'as yet unclassified' }
SBUnknown >> drawInvalidBorderOn: aCanvas [

	" if we have a label do not draw a strong red border "
	self contents
		ifNotEmpty: [aCanvas frameRectangle: self bounds width: 1 * self scalingFactor color: (Color red alpha: 0.7)]
		ifEmpty: [super drawInvalidBorderOn: aCanvas]
]

{ #category : #accessing }
SBUnknown >> endInput [
	<inputAction>
	
	self sandblockEditor endInput.
	self deleteIfDismissed ifTrue: [
		self sandblockEditor do: ((SBDeleteCommand newFor: self containingArtefact) target: self)]
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
	
	deleteIfDismissed := false.
	
	self currentTextMorph italic; colorAlpha: 0.7
]

{ #category : #testing }
SBUnknown >> isExpression [

	^ true
]

{ #category : #testing }
SBUnknown >> isUnknown [

	^ true
]

{ #category : #'as yet unclassified' }
SBUnknown >> keyStroke: anEvent [

	self acceptCharacter: anEvent keyCharacter
]

{ #category : #actions }
SBUnknown >> label: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBUnknown >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self currentTextMorph layoutCommands}
]

{ #category : #accessing }
SBUnknown >> moveCursorTo: aNumber [

	self currentTextMorph moveCursorTo: aNumber
]

{ #category : #accessing }
SBUnknown >> newNullBlock [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown'
]

{ #category : #'as yet unclassified' }
SBUnknown >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [self contents: ''; moveCursorTo: 0]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBUnknown >> stopEditing [

	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
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

{ #category : #actions }
SBUnknown >> tryDelete [

	| editor p |
	p := self previousBlock.
	editor := self sandblockEditor.
	
	self deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false
]

{ #category : #testing }
SBUnknown >> valid [

	^ false
]

{ #category : #accessing }
SBUnknown >> wasDeselected [

	| editor |
	editor := self sandblockEditor.
	(self deleteIfDismissed and: [editor notNil]) ifTrue: [ | wasInput previousSelection |
		previousSelection := editor selection.
		wasInput := editor mode = #input.
		self sandblockEditor do: ((SBDeleteCommand newFor: self containingArtefact) target: self).
		
		previousSelection ifNotNil: [
			previousSelection select.
			wasInput ifTrue: [editor startInput: previousSelection at: 900000000 replacingContents: false]]]
]

{ #category : #'as yet unclassified' }
SBUnknown >> writeSourceOn: aStream [
]
