Class {
	#name : #SBScmLiteral,
	#superclass : #SBScmASTNode,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmLiteral >> acceptInputEvent: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		SBScmGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> castToUnknownWhenEmpty [

	^ self symbols first isNil
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> contentsChanged [

	(self castToUnknownWhenEmpty and: [self currentTextMorph contents isEmpty and: [self sandblockEditor ifNotNil: [:e | e mode = #input] ifNil: [false]]]) ifTrue: [
		self replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> deleteBeforeCursor [
	<action>
	<inputAction>

	self contents ifEmpty: [^ self replaceWithUnknown].
	
	self currentTextMorph cursor = 1 ifTrue: [
		{SBScmNumber. SBScmIdentifier} do: [:class | | name |
			name := class new contents: self contents.
			name validContents ifTrue: [
				^ self sandblockEditor
					do: (SBReplaceCommand new
						target: self;
						replacer: name);
					startInputAtEnd]]].
	
	^ super deleteBeforeCursor
]

{ #category : #'colors and color policies' }
SBScmLiteral >> drawnColor [

	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> initialize [

	super initialize.
	
	self
		addMorphBack: (self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> preferredColorIn: aColorPolicy [

	^ aColorPolicy literal
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> replaceWithUnknown [

	| new |
	self isUnknown ifTrue: [^ self].
	
	new := self newNullBlock label: 'expr'.
	self replaceBy: new.
	new moveCursorTo: 0.
	new sandblockEditor replaceInput: new
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self castToUnknownWhenEmpty ifTrue: [self replaceWithUnknown] ifFalse: [
				self
					contents: '';
					moveCursorTo: 0]]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> textMorphClass [

	^ SBOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> useAsScmString [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBScmString new contents: self contents))
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> useAsScmSymbol [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBScmSymbol new contents: self contents))
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> validContents [

	^ self valid
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBScmLiteral >> writeSourceOn: aStream indent: aNumber [

	aStream nextPutAll: self contents
]
