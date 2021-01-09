Class {
	#name : #SBUnknown,
	#superclass : #SBStLiteral,
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
SBUnknown >> contents: aString [

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor currentInput contents: editor currentInput contents, aString allButFirst]
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

	^ grammarHandler ifNil: [SBSmalltalkGrammarHandler new]
]

{ #category : #accessing }
SBUnknown >> grammarHandler: aHandler [

	grammarHandler := aHandler
]

{ #category : #accessing }
SBUnknown >> initialize [

	super initialize.
	
	deleteIfDismissed := false.
	
	text italic; colorAlpha: 0.7
]

{ #category : #'as yet unclassified' }
SBUnknown >> isExpression [

	^ self grammarHandler isKindOf: SBSmalltalkGrammarHandler
]

{ #category : #'as yet unclassified' }
SBUnknown >> isJsExpression [

	^ self grammarHandler isKindOf: SBJsGrammarHandler
]

{ #category : #'as yet unclassified' }
SBUnknown >> isScmExpression [

	^ self grammarHandler isKindOf: SBScmGrammarHandler
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

	text contents: aString
]

{ #category : #accessing }
SBUnknown >> newNullBlock [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown'
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
