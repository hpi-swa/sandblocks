Class {
	#name : #SBDeleteMethodCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldSource'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeleteMethodCommand >> do [

	oldSource := (target currentClass >> target currentSelector) getSourceFromFile.
	target currentClass removeSelector: target currentSelector.
	^ super do
]

{ #category : #'as yet unclassified' }
SBDeleteMethodCommand >> undo [

	target methodClass compile: oldSource.
	^ super undo
]
