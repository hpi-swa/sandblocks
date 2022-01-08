Class {
	#name : #SBShortcut,
	#superclass : #Object,
	#instVars : [
		'character',
		'shift',
		'command',
		'ctrl',
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

{ #category : #converting }
SBShortcut >> , aShortCut [

	^ {self. aShortCut asSandblockShortcut}
]

{ #category : #accessing }
SBShortcut >> anyModifierKeyPressed [

	^ command == true or: [option == true] or: [ctrl == true]
]

{ #category : #converting }
SBShortcut >> asCollection [

	^ {self}
]

{ #category : #converting }
SBShortcut >> asSandblockShortcut [

	^ self
]

{ #category : #accessing }
SBShortcut >> character [

	^ character
]

{ #category : #accessing }
SBShortcut >> character: aCharacter [

	character := aCharacter
]

{ #category : #accessing }
SBShortcut >> command [

	^ command
]

{ #category : #accessing }
SBShortcut >> commandKeyPressed [

	^ command
]

{ #category : #accessing }
SBShortcut >> controlKeyPressed [

	^ ctrl
]

{ #category : #printing }
SBShortcut >> displayString [

	self example: [$p asSandblockShortcut] args: [{}] label: 'p'.
	self example: [$p command] args: [{}] label: 'ctrl+p'.
	self example: [$P command] args: [{}] label: 'ctrl+P'.
	^ String streamContents: [:stream | self printDisplayOn: stream automaticShift: true]
]

{ #category : #printing }
SBShortcut >> displayStringWithoutShift [

	^ String streamContents: [:stream | self printDisplayOn: stream automaticShift: false]
]

{ #category : #'initialize-release' }
SBShortcut >> initialize [

	super initialize.
	
	shift := false.
	modes := #()
]

{ #category : #accessing }
SBShortcut >> keyCharacter [

	^ character
]

{ #category : #'event matching' }
SBShortcut >> matchesEvent: anEvent [

	| shiftedKeys |
	SBToggledCode
		comment: 'needs to be adapted per keyboard layout'
		active: 1
		do: {[shiftedKeys := #($: $" $! $$ $% $/ $( $) $= $; $_ $* $' ${ $^)]}.
	
	anEvent keyCharacter = self character ifFalse: [^ false].
	
	self shiftPressed ifNotNil: [:expected |
		((expected or: [self character isUppercase]) = anEvent shiftPressed
			or: [anEvent keyCharacter <= 32 and: [expected = anEvent shiftPressed]]
			or: [shiftedKeys includes: anEvent keyCharacter]) ifFalse: [^ false]].
	
	self anyModifierKeyPressed = anEvent anyModifierKeyPressed ifFalse: [^ false].
	self commandKeyPressed ifNotNil: [:expected | expected = anEvent commandKeyPressed ifFalse: [^ false]].
	self optionKeyPressed ifNotNil: [:expected | expected = anEvent optionKeyPressed ifFalse: [^ false]].
	self controlKeyPressed ifNotNil: [:expected | expected = anEvent controlKeyPressed ifFalse: [^ false]].
	
	^ true
]

{ #category : #'event matching' }
SBShortcut >> matchesEvent: anEvent mode: aMode [

	^ (self modes isEmpty or: [self modes includes: aMode]) and: [self matchesEvent: anEvent]
]

{ #category : #accessing }
SBShortcut >> modes [

	^ modes
]

{ #category : #accessing }
SBShortcut >> modes: aCollection [

	modes := aCollection
]

{ #category : #accessing }
SBShortcut >> option [

	^ option ifNil: [false]
]

{ #category : #accessing }
SBShortcut >> optionKeyPressed [

	^ option
]

{ #category : #printing }
SBShortcut >> printDisplayOn: aStream automaticShift: aBoolean [

	| p |
	command == true ifTrue: [aStream nextPutAll: 'Cmd '].
	(shift or: [aBoolean and: [character isLetter and: [character isUppercase]]]) ifTrue: [aStream nextPutAll: 'Shift '].
	ctrl ifNotNil: [
		ctrl ifFalse: [aStream nextPutAll: 'no'].
		aStream nextPutAll: 'Ctrl '].
	option ifNotNil: [
		option ifFalse: [aStream nextPutAll: 'no'].
		aStream nextPutAll: 'Opt '].
	
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

{ #category : #printing }
SBShortcut >> printOn: aStream [

	aStream nextPutAll: 'SBShortcut('.
	self printDisplayOn: aStream automaticShift: true.
	aStream nextPut: $)
]

{ #category : #accessing }
SBShortcut >> shiftPressed [

	^ shift
]

{ #category : #accessing }
SBShortcut >> withCommand [

	command := true
]

{ #category : #accessing }
SBShortcut >> withCtrl [

	ctrl := true
]

{ #category : #accessing }
SBShortcut >> withOption [

	option := true
]

{ #category : #accessing }
SBShortcut >> withShift [

	shift := true
]
