Class {
	#name : #SBShortcut,
	#superclass : #Object,
	#instVars : [
		'character',
		'ctrl',
		'command',
		'shift',
		'option',
		'modes'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBShortcut class >> fromEvent: anEvent [

	| s |
	s := self new character: anEvent keyCharacter.
	anEvent controlKeyPressed ifTrue: [s withCommand].
	anEvent commandKeyPressed ifTrue: [s withCommand].
	"anEvent shiftPressed ifTrue: [s withShift]."
	anEvent optionKeyPressed ifTrue: [s withOption].
	^ s
]

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
SBShortcut >> cmdKeyString [

	Smalltalk os platformName = 'Mac OS' ifTrue: [^ 'Cmd '].
	(Smalltalk os platformName = 'Win32' and: [
		character isAlphaNumeric not and: [
			((SBToggledCode
				comment: 'there are some, but surprisingly few, characters that work with ctrl rather than alt on windows'
				active: 1
				do: {[{Character arrowLeft. Character arrowRight. Character escape. Character delete}]}) includes: character) not]]) ifTrue: [^ 'Alt '].
	^ 'Ctrl '
]

{ #category : #'as yet unclassified' }
SBShortcut >> command [

	^ command
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
	^ String streamContents: [:stream | self printDisplayOn: stream automaticShift: true]
]

{ #category : #'as yet unclassified' }
SBShortcut >> displayStringWithoutShift [

	^ String streamContents: [:stream | self printDisplayOn: stream automaticShift: false]
]

{ #category : #'as yet unclassified' }
SBShortcut >> initialize [

	super initialize.
	
	ctrl := false.
	command := false.
	shift := false.
	option := false.
	modes := #()
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
		do: {[shiftedKeys := #($: $" $! $$ $% $/ $( $) $= $; $_ $* $')]}.
	^ anEvent keyCharacter = character and: [(anEvent optionKeyPressed = self option and: [anEvent commandKeyPressed = (self command or: [self option])]) and: [(shift or: [character isUppercase]) = anEvent shiftPressed or: [(anEvent keyCharacter <= 32 and: [shift = anEvent shiftPressed]) or: [shiftedKeys includes: anEvent keyCharacter]]]]
]

{ #category : #'as yet unclassified' }
SBShortcut >> matchesEvent: anEvent mode: aMode [

	^ (self modes isEmpty or: [self modes includes: aMode]) and: [self matchesEvent: anEvent]
]

{ #category : #'as yet unclassified' }
SBShortcut >> modes [

	^ modes
]

{ #category : #'as yet unclassified' }
SBShortcut >> modes: aCollection [

	modes := aCollection
]

{ #category : #'as yet unclassified' }
SBShortcut >> option [

	^ option ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBShortcut >> optionKeyPressed [

	^ option
]

{ #category : #'as yet unclassified' }
SBShortcut >> printDisplayOn: aStream automaticShift: aBoolean [

	| p |
	command ifTrue: [aStream nextPutAll: self cmdKeyString].
	(shift or: [aBoolean and: [character isLetter and: [character isUppercase]]]) ifTrue: [aStream nextPutAll: 'Shift '].
	ctrl ifTrue: [aStream nextPutAll: 'Ctrl '].
	
	character = Character cr ifTrue: [^ aStream nextPutAll: 'enter'].
	character = Character arrowUp ifTrue: [^ aStream nextPutAll: 'up'].
	character = Character arrowDown ifTrue: [^ aStream nextPutAll: 'down'].
	character = Character arrowLeft ifTrue: [^ aStream nextPutAll: 'left'].
	character = Character arrowRight ifTrue: [^ aStream nextPutAll: 'right'].
	
	character = Character pageDown ifTrue: [^ aStream nextPutAll: 'page-down'].
	character = Character pageUp ifTrue: [^ aStream nextPutAll: 'page-up'].
	
	p := character printString.
	aStream nextPutAll: (p first = $$ ifTrue: [p allButFirst] ifFalse: [
		(p beginsWith: 'Character ')
			ifTrue: [p allButFirst: 'Character ' size]
			ifFalse: [p]])
]

{ #category : #'as yet unclassified' }
SBShortcut >> printOn: aStream [

	aStream nextPutAll: 'SBShortcut('.
	self printDisplayOn: aStream automaticShift: true.
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
