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
SBShortcutTest >> testMatchesUpperCase [

	self assert: ($O asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: $O asInteger hand: nil stamp: 0))
]

{ #category : #'as yet unclassified' }
SBShortcutTest >> testNotMatchesArrowKeyShift [

	self deny: (Character arrowLeft asSandblockShortcut matchesEvent: (KeyboardEvent new setType: #keyDown buttons: 8 position: 0 @ 0 keyValue: Character arrowLeft asInteger hand: nil stamp: 0))
]
