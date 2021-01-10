Class {
	#name : #SBLiteral,
	#superclass : #SBScmASTNode,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBLiteral >> acceptInputEvent: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self validContents ifFalse: [
		self currentTextMorph deleteBeforeCursor.
		SBScmGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBLiteral >> castToUnknownWhenEmpty [

	^ true
]

{ #category : #'as yet unclassified' }
SBLiteral >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBLiteral >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBLiteral >> contentsChanged [

	(self castToUnknownWhenEmpty and: [self currentTextMorph contents isEmpty and: [self sandblockEditor ifNotNil: [:e | e mode = #input] ifNil: [false]]]) ifTrue: [
		self replaceWithUnknown]
]

{ #category : #'as yet unclassified' }
SBLiteral >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBLiteral >> initialize [

	super initialize.
	
	self
		addMorphBack: (self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new
]

{ #category : #'as yet unclassified' }
SBLiteral >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBLiteral >> moveCursorTo: aNumber [

	self currentTextMorph moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBLiteral >> replaceWithUnknown [

	| new |
	self isUnknown ifTrue: [^ self].
	
	self stopEditing.
	
	new := self newNullBlock.
	self replaceBy: new.
	new moveCursorTo: 0.
	new sandblockEditor replaceInput: new
]

{ #category : #'as yet unclassified' }
SBLiteral >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self currentTextMorph contents;
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

	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBLiteral >> stopEditing: aCommand [

	aCommand
		newText: self currentTextMorph contents;
		newMorph: self.
	
	self stopEditing
]

{ #category : #'as yet unclassified' }
SBLiteral >> textMorphClass [

	^ SBOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBLiteral >> validContents [

	^ self valid
]

{ #category : #'as yet unclassified' }
SBLiteral >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
