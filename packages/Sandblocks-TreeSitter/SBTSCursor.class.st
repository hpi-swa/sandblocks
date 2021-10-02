Class {
	#name : #SBTSCursor,
	#superclass : #Object,
	#instVars : [
		'library',
		'cursor',
		'atEnd',
		'factory'
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
SBTSCursor >> currentFieldName [

	^ library cursorCurrentFieldName: cursor
]

{ #category : #'as yet unclassified' }
SBTSCursor >> factory [

	^ factory
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
SBTSCursor >> library: aLibrary cursor: aCursor factory: aFactory [

	library := aLibrary.
	cursor := aCursor.
	factory := aFactory
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

	| type |
	type := library nodeType: (library nodeParent: aNode).
	^ (factory delimitedRules includesKey: type) and: [self type = (factory delimitedRules at: type)]
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
