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
		'stringIsLabel',
		'currentBlock',
		'positions',
		'maxRecursionDepth'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #deduplicate }
SBTSRuleExplore class >> deduplicateResults: aCollection [

	| candidates |
	" try and find a minimum of symbols the user hasn't typed "
	SBToggledCode comment: '' active: 1 do: {
		[candidates := aCollection collect: #first].
		[ | min |
			min := 0.
			candidates := OrderedCollection new.
			aCollection do: [:result | | count |
				count := self newLabelCountIn: result first usedLabels: result second.
				count < min ifTrue: [
					min := count.
					candidates removeAll].
				count = min ifTrue: [candidates add: result first]]]}.
	
	" look for blocks that are contain one of the other blocks, starting from their first different ancestor "
	^ candidates reject: [:candidate |
		(candidates anySatisfy: [:compare | | diff |
			diff := candidate firstDifferingBlocksWith: compare do: [:a :b | b unwrapSuperType].
			compare ~= candidate and: [candidate containsEqual: diff]]) or: [candidate leftMostChain anySatisfy: [:root | candidates anySatisfy: [:compare | root ~= compare and: [root hasSameContentsAs: compare]]]]]
]

{ #category : #deduplicate }
SBTSRuleExplore class >> labelCountInTemplate: aTemplate [

	| count |
	count := 0.
	aTemplate allElementsDo: [:elem |
		(elem isKindOf: SBInlineBlockLabel) ifTrue: [count := count + 1].
		(elem isKindOf: SBTSUnknown) ifTrue: [count := count + (self labelCountInTemplate: elem template value)]].
	^ count
]

{ #category : #deduplicate }
SBTSRuleExplore class >> newLabelCountIn: aBlock usedLabels: aCollection [

	| count |
	count := 0.
	aBlock allMorphsDo: [:m |
		((m isKindOf: SBInlineBlockLabel) and: [(aCollection includes: m) not]) ifTrue: [count := count + 1].
		(m isKindOf: SBTSUnknown) ifTrue: [count := count + (self labelCountInTemplate: m template value)]].
	^ count
]

{ #category : #helper }
SBTSRuleExplore >> addResult [

	| copiedReferences copy index |
	copiedReferences := OrderedDictionary new.
	root allMorphsDo: [:m | copiedReferences add: m -> nil].
	copy := root buildCopy.
	index := 1.
	copy allMorphsDo: [:m |
		(copiedReferences atIndex: index) value: m.
		index := index + 1].
	
	results add: {copy. positions copy mapValues: [:block | copiedReferences at: block]}
]

{ #category : #accessing }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	visitedSymbols add: aSymbol
]

{ #category : #stream }
SBTSRuleExplore >> atEnd [

	^ stream atEnd
]

{ #category : #accessing }
SBTSRuleExplore >> canVisitSymbol: aSymbol [

	^ (stack allButLast count: [:pair | (pair second isKindOf: SBInlineBlockSymbol) and: [pair second type = aSymbol]]) <= recursionDepth
]

{ #category : #deduplicate }
SBTSRuleExplore >> deduplicate [

	^ self class deduplicateResults: results
]

{ #category : #explore }
SBTSRuleExplore >> doExplore: aBlock withNested: aSubBlock nestedBefore: aBoolean for: aString startSymbol: aSymbolString [

	matchFullToken := aString notEmpty and: [aString last = Character space].
	stream := (matchFullToken ifTrue: [aString allButLast] ifFalse: [aString]) readStream.
	
	self resetState.
	
	stringIsLabel := aString notEmpty and: [aBlock factory notNil and: [aBlock factory fullTokensInclude: aString withBlanksTrimmed]].
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
					(nestedBlock notNil and: [foundNested not and: [((nestedBefore and: [self position = 0]) or: [nestedBefore not and: [self atEnd]]) and: [template hasSameStructureAs: nestedBlock]]])
						ifTrue: [
							child := nestedBlock buildCopy.
							foundNested := true]
						ifFalse: [child := self push: template].
					block addMorphBack: child]
				ifAbsent: [
					stack removeLast.
					
					self done
						ifTrue: [
							stack ifEmpty: [
								self addResult.
								self restartFromLastChoiceIfDone: [^ self]]]
						ifFalse: [
							((nestedBefore not or: [foundNested]) and: [self tryTakeStreamWith: block])
								ifTrue: [
									stack ifEmpty: [
										self done ifTrue: [self addResult].
										self restartFromLastChoiceIfDone: [^ self]]]
								ifFalse: [self restartFromLastChoiceIfDone: [^ self]]]]]] repeat
]

{ #category : #helper }
SBTSRuleExplore >> done [

	^ self atEnd and: [nestedBlock isNil or: [foundNested]]
]

{ #category : #testing }
SBTSRuleExplore >> expandSymbol: aSymbolBlock [

	^ true
]

{ #category : #explore }
SBTSRuleExplore >> explore: aBlock for: aString [

	^ (self explore: aBlock withNested: nil nestedBefore: false for: aString startSymbol: nil) collect: #first
]

{ #category : #explore }
SBTSRuleExplore >> explore: aBlock withNested: aSubBlock nestedBefore: aBoolean for: aString startSymbol: aSymbolString [

	recursionDepth := 0.
	maxRecursionDepth + 1 timesRepeat: [
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
	maxRecursionDepth := 1
]

{ #category : #accessing }
SBTSRuleExplore >> matchFullToken [

	^ matchFullToken
]

{ #category : #accessing }
SBTSRuleExplore >> maxRecursionDepth: aNumber [

	maxRecursionDepth := aNumber
]

{ #category : #stream }
SBTSRuleExplore >> next [

	stream position + 1 <= positions size ifTrue: [positions at: stream position + 1 put: currentBlock].
	^ stream next
]

{ #category : #stream }
SBTSRuleExplore >> nextMatchAll: aString [

	| save |
	save := self position.
	aString do: [:each |
		self next = each ifFalse: [
			self position: save.
			^ false]].
	^ true
]

{ #category : #stream }
SBTSRuleExplore >> originalContents [

	^ stream originalContents
]

{ #category : #stream }
SBTSRuleExplore >> peek [

	^ stream peek
]

{ #category : #stream }
SBTSRuleExplore >> position [

	^ stream position
]

{ #category : #stream }
SBTSRuleExplore >> position: aNumber [

	stream position: aNumber.
	aNumber + 1 to: stream size do: [:index | positions at: index put: nil]
]

{ #category : #helper }
SBTSRuleExplore >> push: aBlockTemplate [

	| instance |
	instance := aBlockTemplate buildEmpty.
	self done ifTrue: [instance := instance buildDefault].
	stack add: {1. instance}.
	((instance numAlternativesIn: self) > 1 and: [self done not]) ifTrue: [
		self indexFor: instance.
		lastOptions add: {instance. stack collect: [:pair | pair copy]. self position. visitedSymbols copy. foundNested}].
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
	foundNested := false.
	positions := RunArray new: stream size
]

{ #category : #helper }
SBTSRuleExplore >> restartFromLastChoiceIfDone: aBlock [

	| option choice number |
	lastOptions ifEmpty: [^ aBlock value].
	
	option := lastOptions last.
	choice := option first.
	stack := option second collect: [:pair | pair copy].
	self position: option third.
	visitedSymbols := option fourth copy.
	foundNested := option fifth.
	
	number := choiceIndices at: option first put: (choiceIndices at: choice) + 1.
	self assert: number <= (choice numAlternativesIn: self).
	number = (choice numAlternativesIn: self) ifTrue: [lastOptions remove: option].
	
	self assert: (choice ownerChain includes: root).
	choice allMorphsMutableDo: [:m | m ~= choice ifTrue: [m delete]].
	self removeAllMorphsAfter: choice in: root
]

{ #category : #stream }
SBTSRuleExplore >> size [

	^ stream size
]

{ #category : #helper }
SBTSRuleExplore >> skipOptionIn: aBlock [

	| number |
	number := (choiceIndices at: aBlock) + 1.
	choiceIndices at: aBlock put: number.
	number >= (aBlock numAlternativesIn: self) ifTrue: [lastOptions removeAllSuchThat: [:option | option first = aBlock]]
]

{ #category : #testing }
SBTSRuleExplore >> streamContainsBlock [

	^ false
]

{ #category : #accessing }
SBTSRuleExplore >> stringIsLabel [

	^ stringIsLabel
]

{ #category : #helper }
SBTSRuleExplore >> tryTakeStreamWith: aBlock [

	| ret |
	currentBlock := aBlock.
	ret := aBlock takeStreamFrom: self.
	currentBlock := nil.
	^ ret
]
