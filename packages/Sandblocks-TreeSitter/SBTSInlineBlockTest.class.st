Class {
	#name : #SBTSInlineBlockTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testChoiceContinueMatching [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"ab"') size = 1
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testChoiceNested [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"a"') notNil
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testFailSequence [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := SBTSRuleExplore new explore: block value for: '"1'.
	self assert: result isEmpty
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testFailSymbol [

	| block factory result |
	factory := SBMetaBlockFactory new
		at: 'exampleRule'
		putTemplate: (SBInlineBlockLabel new label: 'ABC').
	
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockSymbol new
			type: 'exampleRule'
			factory: factory
			visitedSymbols: Set new.
		SBInlineBlockLabel new label: 'D'}.
	
	result := SBTSRuleExplore new explore: block value for: 'D'.
	self assert: result isEmpty
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchChoice [

	| block result |
	block := SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'. SBInlineBlockLabel new label: 'c'}.
	result := SBTSRuleExplore new explore: block value for: 'a'.
	self assert: 'a' equals: result first firstSubmorph contents.
	self assert: 'a' equals: result second firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchGroup [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := (SBTSRuleExplore new explore: block value for: '"A') first.
	self assert: 3 equals: result submorphCount
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchIncompleteSequence [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'b'}}.
	result := (SBTSRuleExplore new explore: block value for: '"A') first.
	self assert: 4 equals: result submorphCount.
	self assert: 1 equals: result lastSubmorph submorphCount.
	self assert: result lastSubmorph firstSubmorph isUnknown
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchLabel [

	| block result |
	block := SBInlineBlockText new regexString: '\"[A-Z]*'.
	result := (SBTSRuleExplore new explore: block value for: '"AB') first.
	self assert: '"AB' equals: result contents
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMultipleMatches [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {
			SBInlineBlockLabel new label: 'a'.
			SBInlineBlockLabel new label: 'ab'.
			SBInlineBlockLabel new label: 'aaa'.
			SBInlineBlockLabel new label: 'd'}.
		SBInlineBlockLabel new label: '"'}.
	result := SBTSRuleExplore new explore: block for: '"a'.
	self assert: 3 equals: result size.
	self assert: 3 equals: result first submorphCount.
	self assert: 3 equals: result second submorphCount.
	self assert: 3 equals: result third submorphCount
]
