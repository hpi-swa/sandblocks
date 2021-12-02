Class {
	#name : #SBPalette,
	#superclass : #Object,
	#instVars : [
		'stream',
		'content'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPalette class >> buildOn: aContainer [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPalette class >> container: aBlock [

	^ SBPalettePreviewContainer new
		methodClass: nil;
		addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBPalette class >> context [
	" have subclassResponsibility as a marker but use the more graceful failure for newly added palettes "

	^ true ifTrue: [{[:b | false]}] ifFalse: [self subclassResponsibility]
]

{ #category : #'as yet unclassified' }
SBPalette class >> grammarHandler [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPalette class >> matchesBlock: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBPalette class >> newNullBlock [

	^ SBUnknown new grammarHandler: self grammarHandler
]

{ #category : #'as yet unclassified' }
SBPalette class >> newNullBlock: aString [

	^ self newNullBlock label: aString
]
