Class {
	#name : #SBStLiteral,
	#superclass : #SBStASTNode,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStLiteral >> acceptInputEvent: anEvent [

	super keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBStLiteral >> castToUnknownWhenEmpty [

	^ self symbols first isNil
]

{ #category : #'as yet unclassified' }
SBStLiteral >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBStLiteral >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBStLiteral >> contentsChanged [

	(self castToUnknownWhenEmpty and: [text contents isEmpty]) ifTrue: [
		self replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBStLiteral >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBStLiteral >> initialize [

	super initialize.
	
	self
		addMorphBack: (text := self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStLiteral >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBStLiteral >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStLiteral >> isLiteralBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStLiteral >> keyStroke: anEvent [

	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent
]

{ #category : #'colors and color policies' }
SBStLiteral >> preferredColorIn: aColorPolicy [

	^ aColorPolicy literal
]

{ #category : #'as yet unclassified' }
SBStLiteral >> replaceWithUnknown [

	| new |
	self isUnknown ifTrue: [^ self].
	
	new := self newNullBlock label: 'expr'.
	self replaceBy: new.
	new sandblockEditor replaceInput: new
]

{ #category : #'as yet unclassified' }
SBStLiteral >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	(aBoolean and: [self castToUnknownWhenEmpty]) ifTrue: [ | unknown |
		unknown := self newNullBlock.
		self sandblockEditor
			do: (SBReplaceCommand new
				target: self;
				shouldMergeWithNext: true;
				replacer: unknown);
			replaceInput: unknown.
		^ unknown startInputAt: 0 replacingContents: false].
	
	cmd := self inputCommandClass new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self
				contents: '';
				moveCursorTo: 0]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBStLiteral >> startInputCommand [

	^ self inputCommandClass new
		oldMorph: self;
		previousText: self contents;
		yourself
]

{ #category : #'as yet unclassified' }
SBStLiteral >> textMorphClass [

	^ SBOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBStLiteral >> useAsStString [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStString new contents: self contents))
]

{ #category : #'as yet unclassified' }
SBStLiteral >> useAsStSymbol [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStSymbol new contents: self contents))
]
