Class {
	#name : #SBShortcut,
	#superclass : #Object,
	#instVars : [
		'character',
		'ctrl',
		'command',
		'shift'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBShortcut >> , aShortCut [

	^ {self. aShortCut asSandblockShortcut}
]

{ #category : #'as yet unclassified' }
SBShortcut >> asSandblockShortcut [

	^ self
]

{ #category : #'as yet unclassified' }
SBShortcut >> character [

	^ character
]

{ #category : #'as yet unclassified' }
SBShortcut >> character: aCharacter [

	character := aCharacter
]

{ #category : #'as yet unclassified' }
SBShortcut >> initialize [

	super initialize.
	
	ctrl := false.
	command := false.
	shift := false
]

{ #category : #'as yet unclassified' }
SBShortcut >> matchesEvent: anEvent [

	^ anEvent keyCharacter = character
		"and: [ctrl = anEvent controlKeyPressed]"
		and: [command = (anEvent commandKeyPressed or: [anEvent controlKeyPressed])]
		and: [shift not or: [anEvent shiftPressed]]
]

{ #category : #'as yet unclassified' }
SBShortcut >> printOn: aStream [

	aStream nextPutAll: 'SBShortcut('.
	ctrl ifTrue: [aStream nextPutAll: 'ctrl+'].
	command ifTrue: [aStream nextPutAll: 'cmd+'].
	shift ifTrue: [aStream nextPutAll: 'shift+'].
	aStream nextPutAll: character printString.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBShortcut >> withCommand [

	command := true
]

{ #category : #'as yet unclassified' }
SBShortcut >> withCtrl [

	ctrl := true
]

{ #category : #'as yet unclassified' }
SBShortcut >> withShift [

	shift := true
]
