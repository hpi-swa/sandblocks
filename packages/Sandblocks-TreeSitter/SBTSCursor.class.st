Class {
	#name : #SBTSCursor,
	#superclass : #Object,
	#instVars : [
		'library',
		'cursor',
		'atEnd'
	],
	#category : #'Sandblocks-TreeSitter-FFI'
}

{ #category : #'as yet unclassified' }
SBTSCursor >> atEnd [

	^ atEnd
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

	^ (library cursorGotoFirstChild: cursor)
		ifTrue: [
			atEnd := false.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBTSCursor >> gotoNextSibling [

	| ret |
	ret := library cursorGotoNextSibling: cursor.
	[ret and: [self shouldSkipParsedNode: self node]] whileTrue: [ret := library cursorGotoNextSibling: cursor].
	^ atEnd := ret not
]

{ #category : #'as yet unclassified' }
SBTSCursor >> gotoParent [

	atEnd := false.
	^ library cursorGotoParent: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> initialize [

	super initialize.
	atEnd := false
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
SBTSCursor >> position [

	^ self createRestorePoint
]

{ #category : #'as yet unclassified' }
SBTSCursor >> position: aPosition [

	self restoreTo: aPosition
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

{ #category : #'as yet unclassified' }
SBTSCursor >> visitTextSlot: aSlot morph: aMorph [

	aMorph textFieldPattern: aSlot regex.
	aMorph contents: self text.
	true
]
