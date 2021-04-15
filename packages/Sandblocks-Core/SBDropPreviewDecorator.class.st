Class {
	#name : #SBDropPreviewDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'outline'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDropPreviewDecorator >> initialize [

	super initialize.
	
	outline := false
]

{ #category : #'as yet unclassified' }
SBDropPreviewDecorator >> outline: aBoolean [

	outline := aBoolean
]

{ #category : #'as yet unclassified' }
SBDropPreviewDecorator >> postDrawOn: aCanvas [

	outline
		ifTrue: [aCanvas frameRectangle: self morph bounds width: 3 color: SBDropInsertMarker markerColor]
		ifFalse: [aCanvas fillRectangle: self morph bounds color: SBDropInsertMarker markerColor]
]
