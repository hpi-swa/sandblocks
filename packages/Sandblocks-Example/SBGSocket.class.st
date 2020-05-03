Class {
	#name : #SBGSocket,
	#superclass : #Morph,
	#instVars : [
		'label'
	],
	#category : 'Sandblocks-Example'
}

{ #category : #'as yet unclassified' }
SBGSocket >> initialize [
	super initialize.
	self changeTableLayout; addMorphBack: (label := TextMorph new);
		addMorphBack: (Morph new extent: 12 asPoint); color: Color transparent
]

{ #category : #'as yet unclassified' }
SBGSocket >> label [
	^ label contents
]

{ #category : #'as yet unclassified' }
SBGSocket >> label: aString [ 
	label contents: aString
]
