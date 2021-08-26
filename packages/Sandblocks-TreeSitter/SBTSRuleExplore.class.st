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
		'results',
		'foundNested'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock for: aString [

	^ self explore: aBlock for: aString startSymbol: nil
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
			(block unbuiltChildrenIn: self)
				at: index
				ifPresent: [:template | | child |
					pair at: 1 put: index + 1.
					child := self push: template.
					block addMorphBack: child.
					stream atEnd ifTrue: [child buildDefault]]
				ifAbsent: [
					stack removeLast.
					
					stream atEnd
						ifTrue: [
							stack ifEmpty: [
								results add: root buildCopy.
								self restartFromLastChoiceIfDone: [^ results]]]
						ifFalse: [
							(block takeStreamFrom: self)
								ifTrue: [
									stack ifEmpty: [
										stream atEnd ifTrue: [results add: root buildCopy].
										self restartFromLastChoiceIfDone: [^ results]]]
								ifFalse: [self restartFromLastChoiceIfDone: [^ results]]]]]] repeat
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock withNested: aSubBlock for: aString [

	stack := OrderedCollection new.
	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	matchFullToken := aString last = Character space.
	stream := (matchFullToken ifTrue: [aString allButLast] ifFalse: [aString]) readStream.
	visitedSymbols := Set new.
	results := OrderedCollection new.
	foundNested := false.
	
	root := self push: aBlock.
	
	[
		[stack notEmpty] whileTrue: [ | index block pair |
			pair := stack last.
			index := pair first.
			block := pair second.
			(block unbuiltChildrenIn: self)
				at: index
				ifPresent: [:template | | child |
					pair at: 1 put: index + 1.
					((template hasSameStructureAs: aSubBlock) and: [foundNested not])
						ifTrue: [
							child := aSubBlock buildCopy.
							foundNested := true]
						ifFalse: [
							child := self push: template.
							stream atEnd ifTrue: [child buildDefault]].
					block addMorphBack: child]
				ifAbsent: [
					stack removeLast.
					
					stream atEnd
						ifTrue: [
							stack ifEmpty: [
								results add: root buildCopy.
								self restartFromLastChoiceIfDone: [^ results]]]
						ifFalse: [
							(block takeStreamFrom: self)
								ifTrue: [
									stack ifEmpty: [
										(stream atEnd and: [foundNested]) ifTrue: [results add: root buildCopy].
										self restartFromLastChoiceIfDone: [^ results]]]
								ifFalse: [self restartFromLastChoiceIfDone: [^ results]]]]]] repeat
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
	((aBlock isKindOf: SBInlineBlockChoice) and: [stream atEnd not]) ifTrue: [
		self indexFor: template.
		lastOptions add: {template. stack collect: [:pair | pair copy]. stream position. visitedSymbols copy. foundNested}].
	^ template
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> removeAllMorphsAfter: aMorph in: aParentMorph [

	| delete toDelete |
	delete := false.
	toDelete := OrderedCollection new.
	aParentMorph allMorphsMutableDo: [:m |
		(delete and: [(aMorph hasOwner: m) not])
			ifTrue: [SBToggledCode comment: '' active: 1 do: {[toDelete add: m]. [m delete]}]
			ifFalse: [m = aMorph ifTrue: [delete := true]]].
	toDelete do: #delete
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
	foundNested := option fifth.
	
	number := choiceIndices at: option first put: (choiceIndices at: choice) + 1.
	number = choice alternatives size ifTrue: [lastOptions removeLast].
	
	self assert: (choice ownerChain includes: root).
	choice allMorphsMutableDo: [:m | m ~= choice ifTrue: [m delete]].
	self removeAllMorphsAfter: choice in: root
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> sanityCheck [

	lastOptions do: [:opt | self assert: (opt first ownerChain includes: root)]
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> stream [

	^ stream
]
