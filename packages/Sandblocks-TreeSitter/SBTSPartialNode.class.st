Class {
	#name : #SBTSPartialNode,
	#superclass : #Object,
	#instVars : [
		'index',
		'children',
		'visitedSymbols',
		'parent'
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
SBTSPartialNode >> addLeafIf: aBlock [

	^ self add: nil if: aBlock
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
SBTSPartialNode >> size [

	^ children inject: 0 into: [:sum :c | sum + c childSize]
]
