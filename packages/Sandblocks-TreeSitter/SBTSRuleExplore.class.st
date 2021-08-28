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
		'nestedBlock',
		'nestedBefore'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #accessing }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #helper }
SBTSRuleExplore >> done [

	^ stream atEnd and: [nestedBlock isNil or: [foundNested]]
]

{ #category : #explore }
SBTSRuleExplore >> explore: aBlock for: aString [

	^ self explore: aBlock withNested: nil nestedBefore: false for: aString startSymbol: nil
]

{ #category : #explore }
SBTSRuleExplore >> explore: aBlock withNested: aSubBlock nestedBefore: aBoolean for: aString startSymbol: aSymbolString [

	matchFullToken := aString last = Character space.
	stream := (matchFullToken ifTrue: [aString allButLast] ifFalse: [aString]) readStream.
	nestedBlock := aSubBlock.
	nestedBefore := aBoolean.
	
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
					(nestedBlock notNil and: [foundNested not and: [((nestedBefore and: [stream position = 0]) or: [nestedBefore not and: [stream atEnd]]) and: [template hasSameStructureAs: nestedBlock]]])
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
							((nestedBefore not or: [foundNested]) and: [block takeStreamFrom: self])
								ifTrue: [
									stack ifEmpty: [
										self done ifTrue: [results add: root buildCopy].
										self restartFromLastChoiceIfDone: [^ results]]]
								ifFalse: [self restartFromLastChoiceIfDone: [^ results]]]]]] repeat
]

{ #category : #accessing }
SBTSRuleExplore >> hasSeenChoice: aChoice [

	^ choiceIndices includesKey: aChoice
]

{ #category : #accessing }
SBTSRuleExplore >> hasVisitedSymbol: aSymbol factory: aFactory [

	^ SBToggledCode comment: '' active: 2 do: {
		[false].
		[(stack viewAllButLast count: [:pair | (pair second isKindOf: SBInlineBlockSymbol) and: [pair second type = aSymbol]]) >= (nestedBlock ifNotNil: [1] ifNil: [1])].
		[visitedSymbols includes: aSymbol]}
]

{ #category : #accessing }
SBTSRuleExplore >> indexFor: aChoice [

	^ choiceIndices at: aChoice ifAbsentPut: [1]
]

{ #category : #'initialize-release' }
SBTSRuleExplore >> initialize [

	super initialize.
	
	stack := OrderedCollection new.
	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	visitedSymbols := Set new.
	results := OrderedCollection new.
	foundNested := false
]

{ #category : #accessing }
SBTSRuleExplore >> matchFullToken [

	^ matchFullToken
]

{ #category : #helper }
SBTSRuleExplore >> push: aBlock [

	| template |
	template := aBlock buildEmpty.
	stack add: {1. template}.
	(aBlock numAlternatives > 1 and: [self done not]) ifTrue: [
		self indexFor: template.
		lastOptions add: {template. stack collect: [:pair | pair copy]. stream position. visitedSymbols copy. foundNested}].
	^ template
]

{ #category : #helper }
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

{ #category : #helper }
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

{ #category : #accessing }
SBTSRuleExplore >> stream [

	^ stream
]
