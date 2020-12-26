Class {
	#name : #SBUnknown,
	#superclass : #SBLiteral,
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
	
	deleteIfDismissed := false
]

{ #category : #testing }
SBUnknown >> isUnknown [

	^ true
]

{ #category : #'as yet unclassified' }
SBUnknown >> keyStroke: anEvent [

	self acceptCharacter: anEvent keyCharacter
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

{ #category : #'as yet unclassified' }
SBUnknown >> writeSourceOn: aStream [
]
