Class {
	#name : #SBInputMapping,
	#superclass : #Object,
	#instVars : [
		'editor',
		'registerBlock',
		'extraShortcuts'
	],
	#classVars : [
		'ShortcutProviders'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInputMapping class >> findShortcutProviders [

	^ Array streamContents: [:stream | SBBlock allSubclassesDo: [:class | (class class includesSelector: #registerShortcuts:) ifTrue: [stream nextPut: class]]]
]

{ #category : #'as yet unclassified' }
SBInputMapping class >> initialize [

	SystemChangeNotifier uniqueInstance
		noMoreNotificationsFor: self;
		notify: self ofSystemChangesOfItem: #method using: #methodChanged:
]

{ #category : #'as yet unclassified' }
SBInputMapping class >> methodChanged: anEvent [

	anEvent item isCompiledMethod ifFalse: [^ self].
	(anEvent item methodClass inheritsFrom: SBBlock class) ifFalse: [^ self].
	anEvent item selector = #registerShortcuts: ifFalse: [^ self].
	
	self updateShortcutProviders
]

{ #category : #'as yet unclassified' }
SBInputMapping class >> shortcutProviders [

	^ ShortcutProviders ifNil: [ShortcutProviders := self findShortcutProviders]
]

{ #category : #'as yet unclassified' }
SBInputMapping class >> updateShortcutProviders [

	ShortcutProviders := nil.
	^ self shortcutProviders
]

{ #category : #'event handling' }
SBInputMapping >> actionFor: anEvent mode: aMode do: aBlock ifNone: anotherBlock [

	registerBlock := [:shortcut :action |  | ret |(shortcut asSandblockShortcut matchesEvent: anEvent mode: aMode) ifTrue: [(ret := aBlock value: action) ifTrue: [^ ret]]].
	
	self registerAllShortcuts.
	
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
SBInputMapping >> noInsertShortcut: aShortcut do: aSymbol [

	self shortcut: aShortcut modes: #(#command #input #selection) do: aSymbol
]

{ #category : #'shortcut execute' }
SBInputMapping >> registerAllShortcuts [

	self registerDefaultShortcuts.
	self class shortcutProviders do: [:provider | provider registerShortcuts: self]
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
		self registerAllShortcuts]
]

{ #category : #'event handling' }
SBInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	
]
