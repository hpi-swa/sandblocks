Class {
	#name : #SBTSInlineBlockTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testChoiceContinueMatching [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"ab"') size = 1
]

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testChoiceNested [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"a"') notNil
]

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testFailSequence [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := SBTSRuleExplore new explore: block value for: '"1'.
	self assert: result isEmpty
]

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testFailSequence2 [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockText new regexString: '[0-9]+'.
		SBInlineBlockLabel new label: '.'.
		SBInlineBlockText new regexString: '[A-Z]+'}.
	result := SBTSRuleExplore new explore: block value for: '12.12'.
	self assert: result isEmpty
]

{ #category : #'tests - match empty' }
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

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testFailTooLongLabel [

	| block result |
	block := SBInlineBlockText new regexString: '\"[A-Z]*'.
	result := SBTSRuleExplore new explore: block value for: '"ABaa'.
	self assert: result isEmpty
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchBinaryOp [

	| factory unknown editor num |
	factory := SBMetaBlockFactory new.
	factory
		grammar: '{"supertypes":[]}' nodeTypes: '{}';
		at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSequence new elements: {
				SBInlineBlockSymbol new type: 'expr' factory: factory.
				SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: '-'. SBInlineBlockLabel new label: '+'}.
				SBInlineBlockSymbol new type: 'expr' factory: factory}.
			SBInlineBlockText new regexString: '[0-9]+'}).
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown firstSubmorph keyStroke: (self keyboardEvent: $1).
	num := editor childSandblocks first.
	num keyStroke: (self keyboardEvent: $+).
	self
		assert: '+'
		equals: editor childSandblocks first firstSubmorph submorphs second firstSubmorph contents
]

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testMatchChoice [

	| block result |
	block := SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'. SBInlineBlockLabel new label: 'c'}.
	result := SBTSRuleExplore new explore: block value for: 'a'.
	self assert: 'a' equals: result first firstSubmorph contents.
	self assert: 'ab' equals: result second firstSubmorph contents
]

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testMatchGroup [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := (SBTSRuleExplore new explore: block value for: '"A') first.
	self assert: 3 equals: result submorphCount
]

{ #category : #'tests - match empty' }
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

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testMatchLabel [

	| block result |
	block := SBInlineBlockText new regexString: '\"[A-Z]*'.
	result := (SBTSRuleExplore new explore: block value for: '"AB') first.
	self assert: '"AB' equals: result contents
]

{ #category : #'tests - match empty' }
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

{ #category : #'tests - match empty' }
SBTSInlineBlockTest >> testRegressionAttribute [

	| block result factory |
	factory := SBMetaBlockFactory new.
	factory
		grammar: '{"supertypes":[]}' nodeTypes: '{}';
		at: 'primary_expression' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSequence new elements: {
				SBInlineBlockSymbol new type: 'primary_expression' factory: factory.
				SBInlineBlockLabel new label: '.'.
				SBInlineBlockText new regexString: '[A-Z]+'}.
			SBInlineBlockText new regexString: '[0-9]+'.
			SBInlineBlockText new regexString: '[0-9]+\.[0-9]+'}).
	block := factory getTemplate: 'primary_expression'.
	result := SBTSRuleExplore new explore: block for: '12.34'.
	self assert: 2 equals: result size
]
