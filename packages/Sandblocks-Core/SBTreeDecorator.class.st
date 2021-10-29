Class {
	#name : #SBTreeDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'children',
		'depth',
		'mod',
		'parent',
		'x'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTreeDecorator >> depth: aValue [

	depth := aValue
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> distance [

	^ 1
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> initialize [

	super initialize.
	children := OrderedCollection new.
	depth := 0.
	parent := nil.
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> traverse [

	| index desiredX |
	index := 0.
	self x: 0.
	self children do: [:child | 
		child depth: self depth + 1.
		child traverse. 
		index := index + 1.
		child x: index].
	desiredX := (self children length - 1) / 2.
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> x: aValue [

	x := aValue
]
