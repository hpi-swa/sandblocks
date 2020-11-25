Class {
	#name : #SBShortcut,
	#superclass : #Object,
	#instVars : [
		'character',
		'ctrl',
		'command',
		'shift',
		'option'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBShortcut >> , aShortCut [

	^ {self. aShortCut asSandblockShortcut}
]

{ #category : #'as yet unclassified' }
SBShortcut >> asCollection [

	^ {self}
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
SBShortcut >> commandKeyPressed [

	^ command
]

{ #category : #'as yet unclassified' }
SBShortcut >> controlKeyPressed [

	^ ctrl
]

{ #category : #'as yet unclassified' }
SBShortcut >> displayString [

	SBExample self: [$p asSandblockShortcut] args: [{}] label: 'p'.
	SBExample self: [$p command] args: [{}] label: 'ctrl+p'.
	SBExample self: [$P command] args: [{}] label: 'ctrl+P'.
	^ String streamContents: [:stream | self printDisplayOn: stream]
]

{ #category : #'as yet unclassified' }
SBShortcut >> initialize [

	super initialize.
	
	ctrl := false.
	command := false.
	shift := false.
	option := false
]

{ #category : #'as yet unclassified' }
SBShortcut >> keyCharacter [

	^ character
]

{ #category : #'as yet unclassified' }
SBShortcut >> matchesEvent: anEvent [

	| shiftedKeys |
	SBToggledCode
		comment: 'needs to be adapted per keyboard layout'
		active: 1
		do: {
			[
				shiftedKeys := #($: $" $! $$ $% $/ $( $) $= $; $_ $* $')]
		}.
	^ anEvent keyCharacter = character and: [
		command = (anEvent commandKeyPressed or: [anEvent controlKeyPressed]) and: [
			anEvent optionKeyPressed = self option and: [
				(shift or: [character isUppercase]) = anEvent shiftPressed or: [
					(anEvent keyCharacter <= 32 and: [shift = anEvent shiftPressed]) or: [shiftedKeys includes: anEvent keyCharacter]]]]]
]

{ #category : #'as yet unclassified' }
SBShortcut >> option [

	^ option ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBShortcut >> printDisplayOn: aStream [

	aStream.
	command ifTrue: [aStream nextPutAll: 'Cmd+'].
	shift ifTrue: [aStream nextPutAll: 'Shift+'].
	ctrl ifTrue: [aStream nextPutAll: 'Ctrl+'].
	aStream nextPut: character
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
SBShortcut >> shiftPressed [

	^ shift
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
SBShortcut >> withOption [

	option := true
]

{ #category : #'as yet unclassified' }
SBShortcut >> withShift [

	shift := true
]
