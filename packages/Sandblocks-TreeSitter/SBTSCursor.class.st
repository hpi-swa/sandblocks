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

	| block rule |
	rule := self factory grammar rules
		at: self type
		ifAbsent: [self assert: false].
	
	block := SBMetaBlock new factory: self factory parentSlot: aSlot.
	
	self gotoFirstChild
		ifTrue: [
			self assert: (block slot takeRepeatedFrom: self for: block).
			self gotoParent]
		ifFalse: [block slot takeFrom: self for: block].
	
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

	| ret |
	ret := library cursorGotoNextSibling: cursor.
	[ret and: [self shouldSkipParsedNode: self node]] whileTrue: [ret := library cursorGotoNextSibling: cursor].
	^ ret
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
