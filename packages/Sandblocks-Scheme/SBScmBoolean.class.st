Class {
	#name : #SBScmBoolean,
	#superclass : #SBScmLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmBoolean >> acceptInputEvent: anEvent [

	(#($f $t) includes: anEvent keyCharacter)
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [
			self currentTextMorph deleteBeforeCursor.
			SBScmGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBScmBoolean >> symbols [

	^ #('#' nil)
]

{ #category : #'as yet unclassified' }
SBScmBoolean >> validContents [

	^ self contents = 't' or: [self contents = 'f']
]

{ #category : #'as yet unclassified' }
SBScmBoolean >> writeSourceOn: aStream indent: aNumber [

	aStream nextPut: $#.
	super writeSourceOn: aStream indent: aNumber
]
