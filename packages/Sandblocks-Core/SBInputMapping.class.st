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
SBInputMapping >> cmdShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut modes: #(command selection) do: aSymbol
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
SBInputMapping >> inputShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut modes: #(input) do: aSymbol
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
SBInputMapping >> shortcut: aShortcut modes: aCollection do: aSymbol [

	| shortcut |
	shortcut := aShortcut isCollection
		ifTrue: [aShortcut do: [:s | s modes: aCollection]. aShortcut]
		ifFalse: [aShortcut asSandblockShortcut modes: aCollection; yourself].
	
	editor registerShortcut: shortcut do: aSymbol
]

{ #category : #'as yet unclassified' }
SBInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	
]
