Class {
	#name : #SBShortcutTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesArrowKey [

	self assert: (Character arrowLeft asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 0 position: 0 @ 0 keyValue: Character arrowLeft asInteger hand: nil stamp: 0))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesColon [

	self assert: ($: asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: $: asInteger hand: nil stamp: 0))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesCommandComma [

	| shortcut |
	shortcut := $, command.
	self assert: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: false)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: false))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesCtrlAlt [

	| shortcut |
	shortcut := $v command withCtrl.
	self assert: (shortcut matchesEvent: (SBTest keyboardEvent: $v shift: false command: true control: true))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesEscape [

	self assert: (Character escape asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 0 position: 0 @ 0 keyValue: Character escape asInteger hand: nil stamp: 0))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesModifiedSquareBracket [

	self assert: ($[ asSandblockShortcut matchesEvent: (SBTest keyboardEvent: $[ shift: false command: false)).
	
	"macOS may send cmd with [ and {"
	self assert: ($[ asSandblockShortcut matchesEvent: (SBTest keyboardEvent: $[ shift: false command: true)).
	self assert: (${ asSandblockShortcut matchesEvent: (SBTest keyboardEvent: ${ shift: false command: true))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesShiftCommandComma [

	| shortcut |
	shortcut := $, shift withCommand.
	self assert: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: false)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: false))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testMatchesUpperCase [

	self assert: ($O asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: $O asInteger hand: nil stamp: 0))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testNotMatchesArrowKeyShift [

	self deny: (Character arrowLeft asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: Character arrowLeft asInteger hand: nil stamp: 0))
]
