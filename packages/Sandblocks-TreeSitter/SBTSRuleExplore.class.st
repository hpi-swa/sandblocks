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
		'foundNested',
		'nestedBlock'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> done [

	^ stream atEnd and: [nestedBlock isNil or: [foundNested]]
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock for: aString [

	^ self explore: aBlock withNested: nil for: aString startSymbol: nil
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock withNested: aSubBlock for: aString startSymbol: aSymbolString [

	stack := OrderedCollection new.
	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	matchFullToken := aString last = Character space.
	stream := (matchFullToken ifTrue: [aString allButLast] ifFalse: [aString]) readStream.
	visitedSymbols := Set new.
	results := OrderedCollection new.
	foundNested := false.
	nestedBlock := aSubBlock.
	
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
					(nestedBlock notNil and: [(template hasSameStructureAs: nestedBlock) and: [foundNested not]])
						ifTrue: [
							child := nestedBlock buildCopy.
							foundNested := true]
						ifFalse: [
							child := self push: template.
							self done ifTrue: [child buildDefault]].
					SBToggledCode comment: '' active: 0 do: {
						[
							((child isKindOf: SBInlineBlockSymbol) and: [
								child type = 'binary_operator' and: [
									SBToggledCode comment: '' active: 1 do: {
										[true].
										[(stack count: [:p | (p second isKindOf: SBInlineBlockSymbol) and: [p second type = 'unary_operator']]) = 1]}]]) ifTrue: [self halt]]}.
					block addMorphBack: child]
				ifAbsent: [
					stack removeLast.
					
					self done
						ifTrue: [
							stack ifEmpty: [
								results add: root buildCopy.
								self restartFromLastChoiceIfDone: [^ results]]]
						ifFalse: [
							(block takeStreamFrom: self)
								ifTrue: [
									stack ifEmpty: [
										self done ifTrue: [results add: root buildCopy].
										self restartFromLastChoiceIfDone: [^ results]]]
								ifFalse: [self restartFromLastChoiceIfDone: [^ results]]]]]] repeat
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> hasSeenChoice: aChoice [

	^ choiceIndices includesKey: aChoice
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> hasVisitedSymbol: aSymbol factory: aFactory [

	^ SBToggledCode comment: '' active: 2 do: {
		[false].
		[(stack viewAllButLast count: [:pair | (pair second isKindOf: SBInlineBlockSymbol) and: [pair second type = aSymbol]]) >= (nestedBlock ifNotNil: [1] ifNil: [1])].
		[visitedSymbols includes: aSymbol]}
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
	(aBlock numAlternatives > 1 and: [self done not]) ifTrue: [
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
	number = choice numAlternatives ifTrue: [lastOptions removeLast].
	
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