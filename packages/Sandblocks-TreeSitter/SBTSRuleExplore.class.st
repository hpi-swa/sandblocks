Class {
	#name : #SBTSRuleExplore,
	#superclass : #Object,
	#instVars : [
		'stream',
		'root',
		'matchFullToken',
		'visitedSymbols',
		'choiceIndices',
		'stack',
		'lastOptions',
		'results'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock for: aString startSymbol: aSymbolString [

	stack := OrderedCollection new.
	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	matchFullToken := aString last = Character space.
	stream := (matchFullToken ifTrue: [aString allButLast] ifFalse: [aString]) readStream.
	visitedSymbols := Set new.
	results := OrderedCollection new.
	
	aSymbolString ifNotNil: [visitedSymbols add: aSymbolString].
	
	root := self push: aBlock.
	
	[
		[stack notEmpty] whileTrue: [ | index block pair |
			pair := stack last.
			index := pair first.
			block := pair second.
			(block childrenIn: self)
				at: index
				ifPresent: [:child |
					pair at: 1 put: index + 1.
					stream atEnd
						ifTrue: [block addMorphBack: (child buildEmpty buildDefaultIn: self)]
						ifFalse: [self push: child]]
				ifAbsent: [ | newChild |
					stack removeLast.
					newChild := stream atEnd ifTrue: [block] ifFalse: [
						(block buildIn: nil info: self) ifNotNil: [:b | b] ifNil: [
							self restartFromLastChoiceIfDone: [^ results].
							nil]].
					(stack notEmpty and: [newChild notNil]) ifTrue: [stack last second addMorphBack: newChild].
					stack ifEmpty: [
						results add: root buildCopy.
						self restartFromLastChoiceIfDone: [^ results]]]]] repeat
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> hasSeenChoice: aChoice [

	^ choiceIndices includesKey: aChoice
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> hasVisitedSymbol: aSymbol [

	^ visitedSymbols includes: aSymbol
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> indexFor: aChoice [

	^ choiceIndices at: aChoice ifAbsentPut: [1]
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> matchFullToken [

	^ matchFullToken
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> push: aBlock [

	| template |
	template := aBlock buildEmpty.
	stack add: {1. template}.
	(aBlock isKindOf: SBInlineBlockChoice) ifTrue: [
		self indexFor: template.
		lastOptions add: {template. stack collect: [:pair | pair copy]. stream position. visitedSymbols copy}].
	^ template
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> removeAllMorphsAfter: aMorph in: aParentMorph [

	| delete |
	delete := false.
	aParentMorph allMorphsDo: [:m | delete ifTrue: [m delete] ifFalse: [m = aMorph ifTrue: [delete := true]]]
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> restartFromLastChoiceIfDone: aBlock [

	| option choice number |
	lastOptions ifEmpty: [^ aBlock value].
	
	option := lastOptions last.
	choice := option first.
	stack := option second collect: [:pair | pair copy].
	stream position: option third.
	visitedSymbols := option fourth copy.
	
	number := choiceIndices at: option first put: (choiceIndices at: choice) + 1.
	number = choice alternatives size ifTrue: [lastOptions removeLast].
	
	self removeAllMorphsAfter: choice in: root
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> stream [

	^ stream
]
