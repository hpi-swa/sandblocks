Class {
	#name : #SBInputCommand,
	#superclass : #SBCommand,
	#instVars : [
		'previousText',
		'newText',
		'oldMorph',
		'newMorph'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInputCommand >> block [

	^ self oldMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> contents: aString [

	self newText: aString
]

{ #category : #'as yet unclassified' }
SBInputCommand >> do [

	(oldMorph ~= newMorph and: [newMorph owner isNil]) ifTrue: [oldMorph replaceBy: newMorph].
	self textMorph contents: newText.
	^ newMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> hasChange [

	^ newText ~= previousText or: [newMorph ~= oldMorph]
]

{ #category : #'as yet unclassified' }
SBInputCommand >> isJumpPoint [

	^ self textMorph contents isEmpty
]

{ #category : #'as yet unclassified' }
SBInputCommand >> newMorph [

	^ newMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> newMorph: aMorph [

	newMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> newText [

	^ newText
]

{ #category : #'as yet unclassified' }
SBInputCommand >> newText: aString [

	newText := aString
]

{ #category : #'as yet unclassified' }
SBInputCommand >> oldMorph [

	^ oldMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> oldMorph: aMorph [

	oldMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> previousText [

	^ previousText
]

{ #category : #'as yet unclassified' }
SBInputCommand >> previousText: aString [

	previousText := aString
]

{ #category : #'as yet unclassified' }
SBInputCommand >> setArtefactFrom [

	^ oldMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> target [

	^ newMorph ifNil: [oldMorph]
]

{ #category : #'as yet unclassified' }
SBInputCommand >> textMorph [

	^ (newMorph ifNil: [oldMorph]) currentTextMorph
]

{ #category : #'as yet unclassified' }
SBInputCommand >> undo [

	oldMorph = newMorph ifFalse: [newMorph replaceBy: oldMorph].
	oldMorph contents: previousText.
	^ oldMorph
]
