Class {
	#name : #SBTextCommand,
	#superclass : #SBCommand,
	#instVars : [
		'previousText',
		'newText',
		'oldMorph',
		'newMorph',
		'textMorph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextCommand >> block [

	^ self oldMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> contents: aString [

	self newText: aString
]

{ #category : #'as yet unclassified' }
SBTextCommand >> do [

	(oldMorph ~= newMorph and: [newMorph owner isNil]) ifTrue: [oldMorph replaceBy: newMorph].
	newMorph contents: newText.
	^ newMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> hasChange [

	^ newText ~= previousText or: [newMorph ~= oldMorph]
]

{ #category : #'as yet unclassified' }
SBTextCommand >> newMorph [

	^ newMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> newMorph: aMorph [

	newMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> newText [

	^ newText
]

{ #category : #'as yet unclassified' }
SBTextCommand >> newText: aString [

	newText := aString
]

{ #category : #'as yet unclassified' }
SBTextCommand >> oldMorph [

	^ oldMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> oldMorph: aMorph [

	oldMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> previousText [

	^ previousText
]

{ #category : #'as yet unclassified' }
SBTextCommand >> previousText: aString [

	previousText := aString
]

{ #category : #'as yet unclassified' }
SBTextCommand >> setArtefactFrom [

	^ oldMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> target [

	^ newMorph ifNil: [oldMorph]
]

{ #category : #'as yet unclassified' }
SBTextCommand >> textMorph [

	^ textMorph
]

{ #category : #'as yet unclassified' }
SBTextCommand >> textMorph: aMorph [

	textMorph := aMorph.
	oldMorph := aMorph containingSandblock.
	previousText := aMorph contents
]

{ #category : #'as yet unclassified' }
SBTextCommand >> undo [

	oldMorph = newMorph ifFalse: [newMorph replaceBy: oldMorph].
	oldMorph contents: previousText.
	^ oldMorph
]
