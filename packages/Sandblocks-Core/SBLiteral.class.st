Class {
	#name : #SBLiteral,
	#superclass : #SBASTNode,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLiteral >> acceptInputEvent: anEvent [

	text keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBLiteral >> castToUnknownWhenEmpty [

	^ false
]

{ #category : #'as yet unclassified' }
SBLiteral >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBLiteral >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBLiteral >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBLiteral >> contentsChanged [

	(self castToUnknownWhenEmpty and: [text contents isEmpty]) ifTrue: [
		self replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBLiteral >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBLiteral >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBLiteral >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBLiteral >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBLiteral >> isLiteralBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBLiteral >> keyStroke: anEvent [

	(self isExpression and: [anEvent keyCharacter isSpecial or: [anEvent keyCharacter = Character space]]) ifTrue: [
		(self parentSandblock isMessageSend and: [
			self parentSandblock selector = SBMessageSend placeholderSelector]) ifTrue: [
			^ self sandblockEditor
				endInput;
				startInput: self parentSandblock at: 1 replacingContents: true].
		
		self sandblockEditor endInput.
		^ self wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBLiteral >> moveCursorTo: aNumber [

	text moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBLiteral >> replaceWithUnknown [

	| new |
	self isUnknown ifTrue: [^ self].
	
	self stopEditing.
	
	new := SBUnknown new.
	self replaceBy: new.
	new moveCursorTo: 0.
	new sandblockEditor replaceInput: new
]

{ #category : #'as yet unclassified' }
SBLiteral >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (self inputCommandClass newFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self castToUnknownWhenEmpty
				ifTrue: [self replaceWithUnknown]
				ifFalse: [self contents: ''; moveCursorTo: 0]]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBLiteral >> stopEditing [

	text stopEditing.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBLiteral >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	self stopEditing
]

{ #category : #'as yet unclassified' }
SBLiteral >> textMorphClass [

	^ SBOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBLiteral >> useSuggestion: aString [

	self contents: aString.
	self containingSandblock sandblockEditor endInput
]
