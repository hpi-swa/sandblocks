Class {
	#name : #SBTSQueryTests,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testIgnoresComments [

	| structure |
	structure := SBInlineBlockSymbol new type: 'identifier' factory: nil.
	self assert: (SBTSQuery new
		execute: '(identifier) @id
; comment
(number) @num'
		against: structure
		capturesDo: [:c |
			self assert: (c includesKey: 'id').
			self assert: structure equals: (c at: 'id').
			self deny: (c includesKey: 'num')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchAlternativeAnonymousNodesWithCaptures [

	| structure |
	structure := SBInlineBlockLabel new label: 'a'.
	self assert: (SBTSQuery new execute: '["a" "b" "c"] @keyword' against: structure capturesDo: [:c |
		self assert: (c includesKey: 'keyword').
		self assert: structure equals: (c at: 'keyword')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchAlternativeSymbols [

	self assert: (SBTSQuery new
		execute: '[(identifier) (number)]'
		against: (SBInlineBlockSymbol new type: 'number' factory: nil)
		capturesDo: [:c | ]).
	self assert: (SBTSQuery new
		execute: '[(identifier) (number)]'
		against: (SBInlineBlockSymbol new type: 'identifier' factory: nil)
		capturesDo: [:c | ]).
	self deny: (SBTSQuery new
		execute: '[(identifier) (number)]'
		against: (SBInlineBlockSymbol new type: 'string' factory: nil)
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchAnonymousNode [

	self assert: (SBTSQuery new execute: '"a"' against: (SBInlineBlockLabel new label: 'a') capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchAnyChild [

	| factory |
	factory := SBMetaBlockFactory new.
	self assert: (SBTSQuery new
		execute: '(array (identifier))'
		against: ((SBInlineBlockSymbol new type: 'array' factory: factory)
			addMorphBack: (SBInlineBlockSymbol new type: 'number' factory: factory);
			addMorphBack: (SBInlineBlockSymbol new type: 'identifier' factory: factory))
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchFieldName [

	| factory |
	factory := SBMetaBlockFactory new.
	self assert: (SBTSQuery new
		execute: '(call function: (identifier))'
		against: ((SBInlineBlockSymbol new type: 'call' factory: factory) addMorphBack: (SBInlineBlockSymbol new
			type: 'identifier' factory: factory;
			field: 'function'))
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchMultiple [

	| structure |
	structure := SBInlineBlockSymbol new type: 'identifier' factory: nil.
	self assert: (SBTSQuery new execute: '(identifier) @id (number) @num' against: structure capturesDo: [:c |
		self assert: (c includesKey: 'id').
		self assert: structure equals: (c at: 'id').
		self deny: (c includesKey: 'num')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchNestedSymbols [

	| factory |
	factory := SBMetaBlockFactory new.
	self assert: (SBTSQuery new
		execute: '(array (identifier))'
		against: ((SBInlineBlockSymbol new type: 'array' factory: factory) addMorphBack: (SBInlineBlockRepeat new addMorphBack: (SBInlineBlockSymbol new type: 'identifier' factory: factory)))
		capturesDo: [:c | ]).
	self deny: (SBTSQuery new
		execute: '(array (identifier))'
		against: ((SBInlineBlockSymbol new type: 'array' factory: factory) addMorphBack: (SBInlineBlockRepeat new addMorphBack: (SBInlineBlockSymbol new type: 'number' factory: factory)))
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchNestedSymbolsWithCaptures [

	| factory structure |
	factory := SBMetaBlockFactory new.
	structure := (SBInlineBlockSymbol new type: 'array' factory: factory) addMorphBack: (SBInlineBlockRepeat new addMorphBack: (SBInlineBlockSymbol new type: 'identifier' factory: factory)).
	self assert: (SBTSQuery new execute: '(array (identifier) @i) @a' against: structure capturesDo: [:c |
		self assert: structure equals: (c at: 'a').
		self assert: structure firstSubmorph firstSubmorph equals: (c at: 'i')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchSequence [

	| factory |
	factory := SBMetaBlockFactory new.
	self assert: (SBTSQuery new
		execute: '((comment) (identifier))'
		against: (SBInlineBlockSequence new addAllMorphsBack: {
			SBInlineBlockSymbol new type: 'comment' factory: factory.
			SBInlineBlockSymbol new type: 'identifier' factory: factory})
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchSequenceWithCaptures [

	| structure factory |
	factory := SBMetaBlockFactory new.
	structure := SBInlineBlockSequence new addAllMorphsBack: {
		SBInlineBlockSymbol new type: 'comment' factory: factory.
		SBInlineBlockSymbol new type: 'identifier' factory: factory}.
	self assert: (SBTSQuery new execute: '((comment) @c (identifier) @i)' against: structure capturesDo: [:c |
		self assert: (c includesKey: 'c').
		self assert: structure firstSubmorph equals: (c at: 'c').
		self assert: (c includesKey: 'i')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchSkipCaptures [

	self assert: (SBTSQuery new
		execute: '[(identifier) (number)] (identifier) @tag'
		against: (SBInlineBlockSymbol new type: 'number' factory: nil)
		capturesDo: [:c | self assert: c isEmpty])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchSymbol [

	self assert: (SBTSQuery new
		execute: '(identifier)'
		against: (SBInlineBlockSymbol new type: 'identifier' factory: nil)
		capturesDo: [:c | ]).
	self deny: (SBTSQuery new
		execute: '(identifier1)'
		against: (SBInlineBlockSymbol new type: 'identifier' factory: nil)
		capturesDo: [:c | ]).
	self deny: (SBTSQuery new
		execute: '(identifier1)'
		against: (SBInlineBlockLabel new label: 'label')
		capturesDo: [:c | ])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchSymbolWithCapture [

	| structure |
	structure := SBInlineBlockSymbol new type: 'identifier' factory: nil.
	self assert: (SBTSQuery new execute: '(identifier) @id' against: structure capturesDo: [:c |
		self assert: (c includesKey: 'id').
		self assert: structure equals: (c at: 'id')])
]

{ #category : #'as yet unclassified' }
SBTSQueryTests >> testMatchWildcard [

	| factory structure |
	factory := SBMetaBlockFactory new.
	structure := (SBInlineBlockSymbol new type: 'pair' factory: factory) addMorphBack: (SBInlineBlockSymbol new
		type: 'identifier' factory: factory;
		field: 'key').
	self assert: (SBTSQuery new
		execute: '(pair
  key: (_) @keyword)'
		against: structure
		capturesDo: [:c | self assert: structure firstSubmorph equals: (c at: 'keyword')])
]
