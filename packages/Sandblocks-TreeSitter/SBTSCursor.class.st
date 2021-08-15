Class {
	#name : #SBTSCursor,
	#superclass : #Object,
	#instVars : [
		'library',
		'cursor'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSCursor >> buildMorphFor: aSlot [

	| block rule slots |
	rule := self factory grammar rules
		at: self type
		ifAbsent: [self assert: false].
	
	block := SBMetaBlock new factory: self factory grammarRule: rule slot: aSlot.
	
	slots := block slots readStream.
	
	self gotoFirstChild
		ifTrue: [ | cursorHasNext |
			cursorHasNext := true.
			[slots atEnd] whileFalse: [ | slot count |
				slot := slots next.
				count := 0.
				[cursorHasNext and: [(slot multiple or: [count = 0]) and: [slot takeFrom: self for: block]]] whileTrue: [
					count := count + 1.
					cursorHasNext := self gotoNextSibling.
					[cursorHasNext and: [self shouldSkipParsedNode: self node]] whileTrue: [cursorHasNext := self gotoNextSibling]].
				self assert: (slot required not or: [count > 0])].
			self gotoParent]
		ifFalse: [slots do: [:slot | slot takeFrom: self for: block]].
	
	^ block
]

{ #category : #'as yet unclassified' }
SBTSCursor >> createRestorePoint [

	^ library cursorCopy: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> factory [

	^ library currentFactory
]

{ #category : #'as yet unclassified' }
SBTSCursor >> gotoFirstChild [

	^ library cursorGotoFirstChild: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> gotoNextSibling [

	^ library cursorGotoNextSibling: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> gotoParent [

	^ library cursorGotoParent: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> library: aLibrary cursor: aCursor [

	library := aLibrary.
	cursor := aCursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> node [

	^ library cursorCurrentNode: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> restoreTo: aCursor [

	cursor := aCursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> shouldSkipParsedNode: aNode [
	" TODO: python specific "

	^ (#('argument_list' 'parameters' 'tuple_pattern') includes: (library nodeType: (library nodeParent: aNode))) and: [self type = ',']
]

{ #category : #'as yet unclassified' }
SBTSCursor >> text [

	^ library textForNode: self node
]

{ #category : #'as yet unclassified' }
SBTSCursor >> type [

	^ library nodeType: self node
]
