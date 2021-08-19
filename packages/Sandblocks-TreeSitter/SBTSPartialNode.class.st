Class {
	#name : #SBTSPartialNode,
	#superclass : #Object,
	#instVars : [
		'index',
		'children',
		'visitedSymbols',
		'parent',
		'template'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSPartialNode >> add: aNumber if: aBlock [

	| node |
	node := SBTSPartialNode new
		index: aNumber;
		parent: self;
		yourself.
	^ (aBlock value: node)
		ifTrue: [
			children add: node.
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> addLeaf: aTemplate if: aBlock [

	^ self add: nil if: [:option | aBlock value: (option template: aTemplate)]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> addVisitedSymbol: aString [

	visitedSymbols add: aString
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> childSize [

	^ children
		ifEmpty: [index ifNotNil: [0] ifNil: [1]]
		ifNotEmpty: [children inject: 0 into: [:sum :c | c childSize + sum]]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> children [

	^ children
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> hasVisitedSymbol: aString [

	^ (visitedSymbols includes: aString) or: [self parent ifNotNil: [:p | p hasVisitedSymbol: aString] ifNil: [false]]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> index [

	^ index
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> index: aNumber [

	index := aNumber
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> initialize [

	super initialize.
	
	children := OrderedCollection new.
	visitedSymbols := Set new
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> parent [

	^ parent
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> parent: aNode [

	parent := aNode
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	template ifNotNil: [template printTitleOn: aStream].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> size [

	^ children inject: 0 into: [:sum :c | sum + c childSize]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> template: aTemplate [

	template := aTemplate
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> templates [

	^ Array streamContents: [:s | self templatesDo: [:t | s nextPut: t]]
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> templatesDo: aBlock [

	template ifNotNil: aBlock.
	children do: [:c | c templatesDo: aBlock]
]
