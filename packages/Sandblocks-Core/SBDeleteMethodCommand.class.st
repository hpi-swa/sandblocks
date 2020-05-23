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

	| ret |
	ret := super do.
	oldSource := (target currentClass >> target currentSelector) getSourceFromFile.
	target currentClass removeSelector: target currentSelector.
	^ ret
]

{ #category : #'as yet unclassified' }
SBDeleteMethodCommand >> undo [

	target methodClass compile: oldSource.
	^ super undo
]
