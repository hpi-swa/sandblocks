Class {
	#name : #SBInlineBlockReplace,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockReplace class >> matchAgainst: aBlock [

	| query captures |
	query := (self class >> #matchPython:) pragmas first arguments second.
	captures := nil.
	(SBTSQuery new execute: query against: aBlock capturesDo: [:c | captures := c]) ifTrue: [self matchPython: captures]
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace class >> matchPython: aDictionary [
	<lang: 'python' match: '(call
	(identifier) @open
    (argument_list
    	(string) @path))'>

	(aDictionary at: 'path') contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> initialize [

	super initialize.
	
	self layoutPolicy: TableLayout new
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> layoutCommands [

	^ SBAlgebraCommand morph data: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockReplace >> printTitleOn: aStream [

	aStream nextPutAll: self className
]
