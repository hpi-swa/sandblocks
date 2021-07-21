Class {
	#name : #SBInputMapping,
	#superclass : #Object,
	#instVars : [
		'editor',
		'registerBlock',
		'extraShortcuts'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'event handling' }
SBInputMapping >> actionFor: anEvent mode: aMode do: aBlock ifNone: anotherBlock [

	registerBlock := [:shortcut :action | | ret |
		(shortcut asSandblockShortcut matchesEvent: anEvent mode: aMode)
			ifTrue: [(ret := aBlock value: action) ifTrue: [^ ret]]].
	
	self registerDefaultShortcuts.
	
	^ anotherBlock value
]

{ #category : #accessing }
SBInputMapping >> addShortcuts: aCollection [

	extraShortcuts addAll: aCollection
]

{ #category : #'shortcut execute' }
SBInputMapping >> cmdShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut modes: #(command selection) do: aSymbol
]

{ #category : #accessing }
SBInputMapping >> countModifier [

	^ 0
]

{ #category : #accessing }
SBInputMapping >> defaultState [

	^ self subclassResponsibility
]

{ #category : #'event handling' }
SBInputMapping >> handledEvent: anEvent in: anEditor [
]

{ #category : #'initialize-release' }
SBInputMapping >> initialize [

	super initialize.
	extraShortcuts := OrderedCollection new
]

{ #category : #'shortcut execute' }
SBInputMapping >> inputShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut modes: #(input) do: aSymbol
]

{ #category : #'shortcut execute' }
SBInputMapping >> registerDefaultShortcuts [

	extraShortcuts do: [:s | self registerShortcut: s key do: s value]
]

{ #category : #'shortcut execute' }
SBInputMapping >> registerShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut do: aSymbol
]

{ #category : #'shortcut execute' }
SBInputMapping >> shortcut: aShortcut do: aSymbol [

	registerBlock value: aShortcut value: aSymbol
]

{ #category : #'shortcut execute' }
SBInputMapping >> shortcut: aShortcut modes: aCollection do: aSymbol [

	| shortcut |
	shortcut := aShortcut isCollection
		ifTrue: [aShortcut do: [:s | s modes: aCollection]. aShortcut]
		ifFalse: [aShortcut asSandblockShortcut modes: aCollection; yourself].
	
	self registerShortcut: shortcut do: aSymbol
]

{ #category : #accessing }
SBInputMapping >> shortcuts [

	^ OrderedCollection streamContents: [:stream |
		registerBlock := [:shortcut :action | stream nextPut: shortcut asSandblockShortcut -> action].
		self registerDefaultShortcuts]
]

{ #category : #'event handling' }
SBInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	
]
