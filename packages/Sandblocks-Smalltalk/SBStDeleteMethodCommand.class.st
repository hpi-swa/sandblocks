Class {
	#name : #SBStDeleteMethodCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldSource',
		'category'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeleteMethodCommand >> do [

	| ret |
	ret := super do.
	oldSource := (target currentClass >> target currentSelector) getSourceFromFile.
	category := (target currentClass >> target currentSelector) methodClass category.
	target currentClass removeSelector: target currentSelector.
	^ ret
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCommand >> undo [

	target methodClass compile: oldSource classified: category.
	^ super undo
]
