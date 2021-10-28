Class {
	#name : #SBTSInlineBlockTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #fixtures }
SBTSInlineBlockTest >> exampleLanguageFactory [

	| factory |
	factory := SBMetaBlockFactory new.
	factory
		statementContainerTypes: #('block');
		supertypes: #('primary');
		rootRuleName: 'block';
		at: 'block' putTemplate: (SBInlineBlockRepeat new
			multiple: true
			required: false
			element: (SBInlineBlockChoice new alternatives: {SBInlineBlockSymbol new type: 'primary' factory: factory. SBInlineBlockLabel new label: 'dummy'}));
		at: 'primary' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSymbol new type: 'number' factory: factory.
			SBInlineBlockSymbol new type: 'identifier' factory: factory});
		at: 'number' putTemplate: (SBInlineBlockText new regexString: '[0-9]+');
		at: 'identifier' putTemplate: (SBInlineBlockText new regexString: '[A-Za-z]+');
		at: 'notUsed' putTemplate: (SBInlineBlockLabel new label: 'notUsed').
	^ factory
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testChoiceContinueMatching [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"ab"') size = 1
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testChoiceNested [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (SBTSRuleExplore new explore: block value for: '"a"') notNil
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testConsecutiveIdenticalChoices [

	| block factory result |
	factory := SBMetaBlockFactory new
		at: 'exampleRule'
		putTemplate: (SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'A'. SBInlineBlockLabel new label: 'B'}).
	
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockSymbol new type: 'exampleRule' factory: factory.
		SBInlineBlockSymbol new type: 'exampleRule' factory: factory}.
	
	result := SBTSRuleExplore new explore: block value for: 'BA'.
	self assert: 1 equals: result size
]

{ #category : #'tests - deduplicate' }
SBTSInlineBlockTest >> testDeduplicateExtraChoice [

	| factory result |
	factory := SBMetaBlockFactory new.
	factory
		at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSymbol new type: 'id' factory: factory.
			SBInlineBlockSequence new elements: {
				SBInlineBlockSymbol new type: 'expr' factory: factory.
				SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: '.'. SBInlineBlockLabel new label: '?.'}.
				SBInlineBlockSymbol new type: 'expr' factory: factory}});
		at: 'id' putTemplate: (SBInlineBlockText new regexString: '[a-z]+').
	
	result := SBTSRuleExplore new
		explore: (factory getTemplate: 'expr') for: 'a';
		deduplicate.
	self assert: 1 equals: result size
]

{ #category : #'tests - deduplicate' }
SBTSInlineBlockTest >> testDeduplicateExtraLabels [

	| factory result |
	factory := SBMetaBlockFactory new.
	factory
		at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSymbol new type: 'id' factory: factory.
			SBInlineBlockSequence new elements: {SBInlineBlockSymbol new type: 'expr' factory: factory. SBInlineBlockLabel new label: '=>'}.
			SBInlineBlockSequence new elements: {
				SBInlineBlockSymbol new type: 'expr' factory: factory.
				SBInlineBlockLabel new label: ','.
				SBInlineBlockSymbol new type: 'expr' factory: factory}});
		at: 'id' putTemplate: (SBInlineBlockText new regexString: '[a-z]+').
	
	result := SBTSRuleExplore new
		explore: (factory getTemplate: 'expr') for: 'a';
		deduplicate.
	self assert: 1 equals: result size
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testFailNestedPrefixOp [

	| factory unknown editor num |
	factory := SBMetaBlockFactory new.
	factory
		supertypes: #('primary');
		at: 'expr'
			putTemplate: (SBInlineBlockChoice new alternatives: {SBInlineBlockSymbol new type: 'primary' factory: factory. SBInlineBlockLabel new label: 'dummy'});
		at: 'primary' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSymbol new type: 'number' factory: factory.
			SBInlineBlockSymbol new type: 'prefix_op' factory: factory});
		at: 'number' putTemplate: (SBInlineBlockText new regexString: '[0-9]+');
		at: 'prefix_op' putTemplate: (SBInlineBlockChoice new alternatives: {
			SBInlineBlockSequence new elements: {
				SBInlineBlockLabel new label: '+'.
				SBInlineBlockLabel new label: 'abc'.
				SBInlineBlockSymbol new type: 'primary' factory: factory}.
			SBInlineBlockSequence new elements: {SBInlineBlockLabel new label: '-'. SBInlineBlockSymbol new type: 'primary' factory: factory}}).
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown keyStroke: (self keyboardEvent: $1).
	num := editor childSandblocks first firstBlock.
	
	self assert: (num choicesForInput: '+' before: false) isEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testFailSequence [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := SBTSRuleExplore new explore: block value for: '"1'.
	self assert: result isEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testFailSequence2 [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockText new regexString: '[0-9]+'.
		SBInlineBlockLabel new label: '.'.
		SBInlineBlockText new regexString: '[A-Z]+'}.
	result := SBTSRuleExplore new explore: block value for: '12.12'.
	self assert: result isEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testFailSymbol [

	| block factory result |
	factory := SBMetaBlockFactory new
		at: 'exampleRule'
		putTemplate: (SBInlineBlockLabel new label: 'ABC').
	
	block := SBInlineBlockSequence new elements: {SBInlineBlockSymbol new type: 'exampleRule' factory: factory. SBInlineBlockLabel new label: 'D'}.
	
	result := SBTSRuleExplore new explore: block value for: 'D'.
	self assert: result isEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testFailTooLongLabel [

	| block result |
	block := SBInlineBlockText new regexString: '\"[A-Z]*'.
	result := SBTSRuleExplore new explore: block value for: '"ABaa'.
	self assert: result isEmpty
]

{ #category : #'tests - actions' }
SBTSInlineBlockTest >> testInsertStatement [

	| factory toplevel editor |
	factory := self exampleLanguageFactory.
	toplevel := factory toplevel.
	editor := self editorFor: toplevel.
	toplevel performAction: #insertStatementBelow.
	self assert: editor selection isUnknown.
	self assert: (editor selection template value isKindOf: SBInlineBlockChoice)
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchBinaryOp [

	| factory unknown editor num |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
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

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchChoice [

	| block result |
	block := SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'. SBInlineBlockLabel new label: 'c'}.
	result := SBTSRuleExplore new explore: block value for: 'a'.
	self assert: 'a' equals: result first firstSubmorph contents.
	self assert: 'ab' equals: result second firstSubmorph contents
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchEarlyExplorationStoppedRegression [

	| factory basic editor unknown |
	factory := SBMetaBlockFactory new.
	
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {SBInlineBlockLabel new label: '(?<'. SBInlineBlockSymbol new type: 'nested' factory: factory}.
		SBInlineBlockSymbol new type: 'basic' factory: factory}).
	factory
		at: 'nested'
		putTemplate: (SBInlineBlockChoice new alternatives: {SBInlineBlockSymbol new type: 'expr' factory: factory. SBInlineBlockLabel new label: 'other'}).
	factory at: 'basic' putTemplate: (SBInlineBlockLabel new label: 'basic').
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown keyStroke: (self keyboardEvent: $b).
	basic := editor childSandblocks first.
	self assert: 1 equals: (basic choicesForInput: '(' before: false) size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchFullToken [

	| result factory |
	factory := SBMetaBlockFactory new.
	factory at: 'exampleRule' putTemplate: (SBInlineBlockChoice new
		alternatives: {SBInlineBlockLabel new label: 'ab'. SBInlineBlockText new regexString: '[a-z]+'};
		factory: factory).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'exampleRule') for: 'ab'.
	self assert: 2 equals: result size.
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'exampleRule') for: 'ab '.
	self assert: 1 equals: result size.
	self assert: (result first firstSubmorph isKindOf: SBInlineBlockLabel).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'exampleRule') for: 'a '.
	self assert: 1 equals: result size.
	self assert: (result first firstSubmorph isKindOf: SBInlineBlockText).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'exampleRule') for: 'aba'.
	self assert: 1 equals: result size.
	self assert: (result first firstSubmorph isKindOf: SBInlineBlockText)
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchGroup [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := (SBTSRuleExplore new explore: block value for: '"A') first.
	self assert: 3 equals: result submorphCount
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchIfBeforeAndAfter [

	| factory unknown editor num |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {SBInlineBlockLabel new label: 'if'. SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockSequence new elements: {SBInlineBlockSymbol new type: 'expr' factory: factory. SBInlineBlockLabel new label: 'if'}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	editor := self editorFor: (unknown := SBTSUnknown new
		template: [factory getTemplate: 'expr'];
		type: 'expr' factory: factory).
	unknown keyStroke: (self keyboardEvent: $1).
	num := editor childSandblocks first.
	self assert: 1 equals: (num choicesForInput: 'if' before: true) size.
	self assert: 1 equals: (num choicesForInput: 'if' before: false) size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchIncompleteSequence [

	| block result |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'b'}}.
	result := (SBTSRuleExplore new explore: block value for: '"A') first.
	self assert: 4 equals: result submorphCount.
	self assert: result lastSubmorph isUnknown
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchLastOptionRecursive [
	<timeout: 0.2>

	| factory result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockText new regexString: '[0-9]+'.
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockLabel new label: '+'.
			SBInlineBlockSymbol new type: 'expr' factory: factory}}).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: '1+1+'.
	self assert: result notEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchOptional [

	| block |
	block := SBInlineBlockSequence new elements: {
		SBInlineBlockRepeat new
			multiple: false
			required: false
			element: (SBInlineBlockLabel new label: 'abc').
		SBInlineBlockText new regexString: 'def'}.
	self assert: (SBTSRuleExplore new explore: block value for: 'def') notEmpty
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchPartialLabel [

	| factory unknown editor num label result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockText new regexString: '[0-9]+'.
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: '-='. SBInlineBlockLabel new label: '+='}.
			SBInlineBlockSymbol new type: 'expr' factory: factory}}).
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown keyStroke: (self keyboardEvent: $1).
	num := editor childSandblocks first.
	
	result := num choicesForInput: '+' before: true.
	self assert: 1 equals: result size.
	label := nil.
	result first allMorphsDo: [:morph | (morph isKindOf: SBInlineBlockLabel) ifTrue: [label := morph]].
	self assert: '+=' equals: label contents
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchPrefixOp [

	| factory unknown editor num |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: '-'. SBInlineBlockLabel new label: '+'}.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown keyStroke: (self keyboardEvent: $1).
	num := editor childSandblocks first.
	self assert: 1 equals: (num choicesForInput: '+' before: false) size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchRecursive [

	| factory unknown editor num result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockLabel new label: '+'.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: '1+1+'.
	self assert: result notEmpty.
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown tryInterpretInput: '1+1+'.
	num := editor childSandblocks first.
	self assert: '1 + 1 + ' equals: num sourceString
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchRecursiveNested [
	<timeout: 0.2>

	| factory result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockLabel new label: '+'.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: '1+1+'.
	self assert: result notEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchRecursiveNumberOnly [

	| factory result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockLabel new label: '+'.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	result := SBTSRuleExplore new explore: (SBInlineBlockSymbol new type: 'expr' factory: factory) for: '11'.
	self assert: 1 equals: result size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchRecursiveSimple [
	<timeout: 0.2>

	| factory result |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'expr' factory: factory.
			SBInlineBlockLabel new label: '+'.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockText new regexString: '[0-9]+'}).
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: '1+1'.
	self assert: result notEmpty
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchWithSeparator [

	| factory result |
	factory := SBMetaBlockFactory new.
	factory
		at: 'expr' putTemplate: (SBInlineBlockChoice new
			alternatives: {
				SBInlineBlockSequence new elements: {
					SBInlineBlockLabel new
						label: 'def';
						factory: factory.
					SBInlineBlockText new regexString: '[a-z]+'}.
				SBInlineBlockText new regexString: '[a-z]+'};
			factory: factory);
		grammar: (JsonObject fromAssociations: {
			#rules -> (JsonObject fromAssociations: {#word -> (JsonObject fromAssociations: {#type -> 'PATTERN'. #value -> '[a-z]+'})})});
		wordRule: 'word'.
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: 'de'.
	self assert: 2 equals: result size.
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: 'def '.
	self assert: 1 equals: result size.
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: 'defa'.
	self assert: 1 equals: result size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testMatchWithSeparatorNonAlphanum [

	| factory result |
	factory := SBMetaBlockFactory new.
	factory
		at: 'expr' putTemplate: (SBInlineBlockChoice new
			alternatives: {
				SBInlineBlockSequence new elements: {
					SBInlineBlockLabel new
						label: '+';
						factory: factory.
					SBInlineBlockText new regexString: '[a-z]+'}.
				SBInlineBlockText new regexString: '[a-z]+'};
			factory: factory);
		grammar: (JsonObject fromAssociations: {
			#rules -> (JsonObject fromAssociations: {#word -> (JsonObject fromAssociations: {#type -> 'PATTERN'. #value -> '[a-z]+'})})});
		wordRule: 'word'.
	
	result := SBTSRuleExplore new explore: (factory getTemplate: 'expr') for: '+'.
	self assert: 1 equals: result size
]

{ #category : #'tests - continue match' }
SBTSInlineBlockTest >> testMatchWithUnknownBetween [

	| factory basic editor unknown choices |
	factory := SBMetaBlockFactory new.
	factory at: 'expr' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockLabel new label: '(?<'.
			SBInlineBlockSymbol new type: 'other' factory: factory.
			SBInlineBlockSymbol new type: 'expr' factory: factory}.
		SBInlineBlockSymbol new type: 'basic' factory: factory}).
	factory at: 'basic' putTemplate: (SBInlineBlockLabel new label: 'basic').
	factory
		at: 'other'
		putTemplate: (SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'other'. SBInlineBlockLabel new label: 'yetother'}).
	
	editor := self editorFor: (unknown := factory instantiateTemplate: 'expr').
	unknown keyStroke: (self keyboardEvent: $b).
	basic := editor childSandblocks first.
	choices := basic choicesForInput: '(' before: false.
	self assert: 1 equals: choices size.
	self assert: choices first childSandblocks first isUnknown
]

{ #category : #'tests - match in unknown' }
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

{ #category : #'tests - actions' }
SBTSInlineBlockTest >> testPasteAfter [

	| factory toplevel editor newBlock firstBlock |
	factory := self exampleLanguageFactory.
	toplevel := factory toplevel.
	editor := self editorFor: toplevel.
	toplevel addBlock: (firstBlock := (factory instantiateTemplate: 'number') contents: '123').
	editor copyBuffer: (newBlock := (factory instantiateTemplate: 'number') contents: '456').
	firstBlock performAction: #pasteAfter.
	self assert: 2 equals: toplevel childSandblocks size
]

{ #category : #'tests - match in unknown' }
SBTSInlineBlockTest >> testRegressionAttribute [

	| result factory |
	factory := SBMetaBlockFactory new.
	factory at: 'primary_expression' putTemplate: (SBInlineBlockChoice new alternatives: {
		SBInlineBlockSequence new elements: {
			SBInlineBlockSymbol new type: 'primary_expression' factory: factory.
			SBInlineBlockLabel new label: '.'.
			SBInlineBlockText new regexString: '[A-Z]+'}.
		SBInlineBlockText new regexString: '[0-9]+'.
		SBInlineBlockText new regexString: '[0-9]+\.[0-9]+'}).
	result := SBTSRuleExplore new explore: (SBInlineBlockSymbol new type: 'primary_expression' factory: factory)  for: '12.34'.
	self assert: 1 equals: result size
]

{ #category : #'tests - actions' }
SBTSInlineBlockTest >> testRejectsPasteAfter [

	| factory toplevel editor newBlock firstBlock |
	factory := self exampleLanguageFactory.
	toplevel := factory toplevel.
	editor := self editorFor: toplevel.
	toplevel addBlock: (firstBlock := (factory instantiateTemplate: 'number') contents: '123').
	editor copyBuffer: (newBlock := factory instantiateTemplate: 'notUsed').
	firstBlock performAction: #pasteAfter.
	self assert: 1 equals: toplevel childSandblocks size
]
