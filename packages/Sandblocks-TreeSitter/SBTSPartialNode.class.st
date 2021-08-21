Class {
	#name : #SBTSPartialNode,
	#superclass : #Object,
	#instVars : [
		'index',
		'children',
		'visitedSymbols',
		'parent',
		'template',
		'optionIndices',
		'sequences'
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
	visitedSymbols := Set new.
	optionIndices := Dictionary new
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> nextOption [

	| i sequence |
	
	visitedSymbols := Set new.
	sequences ifNil: [sequences := (self sequencesOf: (optionIndices keys collect: [:block | block alternatives size])) readStream].
	
	sequences atEnd ifTrue: [^ false].
	
	i := 1.
	sequence := sequences next.
	optionIndices keysDo: [:block |
		optionIndices at: block put: (sequence at: i ifAbsent: [1]).
		i := i + 1].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBTSPartialNode >> optionAt: aChoiceBlock ifAbsentPut: aBlock [

	sequences ifNotNil: [" FIXME: need to still allow changes but without destroying our system "
	^ optionIndices at: aChoiceBlock ifAbsent: [1]].
	^ optionIndices at: aChoiceBlock ifAbsentPut: aBlock
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
SBTSPartialNode >> sequencesOf: nums [

	| arr |
	nums ifEmpty: [^ nums].
	
	arr := (Array new: (nums reduce: [:a :b | a * b])) collect: [:x | Array new: nums size].
	nums withIndexDo: [:max :index | | beforeMe i |
		beforeMe := (nums viewFrom: 1 to: index - 1)
			inject: 1
			into: [:prod :cur | prod * cur].
		i := 1.
		arr size / (max * beforeMe) timesRepeat: [
			1 to: max do: [:cur |
				beforeMe timesRepeat: [
					(arr at: i) at: index put: cur.
					i := i + 1]]]].
	^ arr
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
