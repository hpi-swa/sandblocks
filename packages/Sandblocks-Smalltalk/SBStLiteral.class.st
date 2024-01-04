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

{ #category : #actions }
SBStLiteral >> wrapInVariantCoveringRange [
	<action>
	
	| rangeString collection |
	rangeString := UIManager default
		request: 'Enter any collection of literals as alternatives.'
		initialAnswer: '1 to: 3, #($a $b $c), {''foo''. ''bar''. ''Squeak''.}...'.
	((rangeString isNil) or: [rangeString = '']) ifTrue: [^ self].
	
	collection := [Compiler evaluate: rangeString] on: Error do: [:ex | UIManager inform: 'Not valid code'. ^ self].
	collection isCollection ifFalse: [UIManager inform: 'Not a valid Collection'. ^ self].
	
	(collection isInterval and: [collection start > collection stop])
		ifTrue: [collection := collection stop to: collection start. collection := collection reversed].
	
	self wrapInVariantGivenCollection: collection
]

{ #category : #actions }
SBStLiteral >> wrapInVariantGivenCollection: aCollection [
	
	| variant |
	variant := SBVariant new.
	self sandblockEditor do:
		(SBWrapCommand new
			selectAfter: #block;
			outer: variant;
			inner: self;
			wrap: [:outer :inner | variant 
				named: aCollection asString
				alternatives: (aCollection collect: [:anObject | 
					SBNamedBlock block: (SBStBlockBody new 
						statements: {(
						(anObject isString and: anObject isSymbol not) 
							ifTrue: [SBStString new contents: anObject]
							ifFalse: [anObject asString parseAsSandblock])}) 
						named: anObject asString])
				activeIndex: 1])
]
