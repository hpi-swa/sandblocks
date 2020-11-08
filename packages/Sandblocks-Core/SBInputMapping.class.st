Class {
	#name : #SBInputMapping,
	#superclass : #Object,
	#instVars : [
		'editor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInputMapping >> applyFor: anEditor [

	editor := anEditor.
	editor clearShortcuts.
	self registerDefaultShortcuts
]

{ #category : #'as yet unclassified' }
SBInputMapping >> countModifier [

	^ 0
]

{ #category : #'as yet unclassified' }
SBInputMapping >> defaultState [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInputMapping >> handledEvent: anEvent in: anEditor [
]

{ #category : #'as yet unclassified' }
SBInputMapping >> registerDefaultShortcuts [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInputMapping >> registerShortcut: aShortcut do: aSymbol [

	editor registerShortcut: aShortcut do: aSymbol
]

{ #category : #'as yet unclassified' }
SBInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	
]
