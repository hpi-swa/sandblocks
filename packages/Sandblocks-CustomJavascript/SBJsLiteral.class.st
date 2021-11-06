Class {
	#name : #SBJsLiteral,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsLiteral >> acceptInputEvent: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		SBJsGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> castToUnknownWhenEmpty [

	^ self symbols first isNil
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> contentsChanged [

	(self castToUnknownWhenEmpty and: [self currentTextMorph contents isEmpty and: [self sandblockEditor ifNotNil: [:e | e mode = #input] ifNil: [false]]]) ifTrue: [
		self replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> deleteBeforeCursor [
	<action>
	<inputAction>
	
	self contents ifEmpty: [^ self replaceWithUnknown].
	
	^ super deleteBeforeCursor
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> initialize [

	super initialize.
	
	self
		addMorphBack: (self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> preferredColorIn: aColorPolicy [

	^ aColorPolicy literal
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> replaceWithUnknown [

	| new |
	self isUnknown ifTrue: [^ self].
	
	self stopEditing.
	
	new := self newNullBlock.
	self replaceBy: new.
	new currentTextMorph moveCursorTo: 0.
	new sandblockEditor replaceInput: new
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
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
SBJsLiteral >> startInputCommand [

	^ SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> stopEditing [

	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	self stopEditing
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> textMorphClass [

	^ SBOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> validContents [

	^ self valid
]

{ #category : #'as yet unclassified' }
SBJsLiteral >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
