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
		'nestedBefore',
		'recursionDepth',
		'stringIsLabel'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #accessing }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #accessing }
SBTSRuleExplore >> canVisitSymbol: aSymbol [

	^ (stack allButLast count: [:pair | (pair second isKindOf: SBInlineBlockSymbol) and: [pair second type = aSymbol]]) <= recursionDepth
]

{ #category : #explore }
SBTSRuleExplore >> doExplore: aBlock withNested: aSubBlock nestedBefore: aBoolean for: aString startSymbol: aSymbolString [

	self resetState.
	
	matchFullToken := aString notEmpty and: [aString last = Character space].
	stringIsLabel := aString notEmpty and: [aBlock factory notNil and: [aBlock factory fullTokensInclude: aString withBlanksTrimmed]].
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
							self done ifTrue: [child := child buildDefault]].
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

	recursionDepth := 0.
	2 timesRepeat: [
		self
			doExplore: aBlock
			withNested: aSubBlock
			nestedBefore: aBoolean
			for: aString
			startSymbol: aSymbolString.
		
		results ifNotEmpty: [^ results].
		recursionDepth := recursionDepth + 1].
	^ results
]

{ #category : #helper }
SBTSRuleExplore >> hasOptionOnStack: aBlock [

	self flag: #fixme.
	" is it =2? or is it =indexOf(recur)? "
	^ stack anySatisfy: [:pair | (pair second hasSameStructureAs: aBlock) and: [pair first = 2]]
]

{ #category : #accessing }
SBTSRuleExplore >> hasSeenChoice: aChoice [

	^ choiceIndices includesKey: aChoice
]

{ #category : #accessing }
SBTSRuleExplore >> indexFor: aChoice [

	^ choiceIndices at: aChoice ifAbsentPut: [1]
]

{ #category : #'initialize-release' }
SBTSRuleExplore >> initialize [

	super initialize.
	
	
]

{ #category : #accessing }
SBTSRuleExplore >> matchFullToken [

	^ matchFullToken
]

{ #category : #helper }
SBTSRuleExplore >> push: aBlockTemplate [

	| instance |
	instance := aBlockTemplate buildEmpty.
	stack add: {1. instance}.
	(aBlockTemplate numAlternatives > 1 and: [self done not]) ifTrue: [
		self indexFor: instance.
		lastOptions add: {instance. stack collect: [:pair | pair copy]. stream position. visitedSymbols copy. foundNested}].
	^ instance
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

{ #category : #'initialize-release' }
SBTSRuleExplore >> resetState [

	stack := OrderedCollection new.
	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	visitedSymbols := Set new.
	results := OrderedCollection new.
	foundNested := false
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
	self assert: number <= choice numAlternatives.
	number = choice numAlternatives ifTrue: [lastOptions remove: option].
	
	self assert: (choice ownerChain includes: root).
	choice allMorphsMutableDo: [:m | m ~= choice ifTrue: [m delete]].
	self removeAllMorphsAfter: choice in: root
]

{ #category : #helper }
SBTSRuleExplore >> skipOptionIn: aBlock [

	| number |
	number := (choiceIndices at: aBlock) + 1.
	choiceIndices at: aBlock put: number.
	number >= aBlock numAlternatives ifTrue: [
		lastOptions removeAllSuchThat: [:option | option first = aBlock]]
]

{ #category : #accessing }
SBTSRuleExplore >> stream [

	^ stream
]

{ #category : #accessing }
SBTSRuleExplore >> stringIsLabel [

	^ stringIsLabel
]
