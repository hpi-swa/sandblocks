Class {
	#name : #SBMetaBlockFactory,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'nodeTypes'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: rule [

	| s |
	s := '' writeStream.
	self buildRegex: rule on: s.
	^ s contents asRegex
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: anObject on: aStream [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [^ self buildRegex: anObject content on: aStream].
	
	(anObject at: #type) caseOf: {
		['REPEAT'] -> [
			self buildRegex: anObject content on: aStream.
			aStream nextPut: $*].
		['PATTERN'] -> [
			aStream nextPut: $(.
			aStream nextPutAll: (anObject at: #value).
			aStream nextPut: $)].
		['CHOICE'] -> [
			aStream nextPut: $(.
			anObject members
				do: [:c | self buildRegex: c on: aStream]
				separatedBy: [aStream nextPut: $|].
			aStream nextPut: $)].
		['SEQ'] -> [anObject members do: [:c | self buildRegex: c on: aStream]].
		['STRING'] -> [
			aStream nextPut: $(.
			aStream nextPutAll: (self escapeStringForRegex: (anObject at: #value)).
			aStream nextPut: $)].
		['BLANK'] -> []}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRule: aString [

	^ SBToggledCode comment: '' active: 1 do: {
		[self fromSTType: (nodeTypes detect: [:type | type type = aString])].
		[ | rule |
			rule := grammar rules at: aString.
			rule := self cleanRule: rule.
			rule explore.
			^ SBMetaBlock new addMorphBack: (self fromTSRule: rule)]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> cleanRule: aRule [

	^ aRule type
		caseOf: {
			['CHOICE'] -> [
				(aRule members size = 2 and: [aRule members contains: [:m | m type = 'BLANK']])
					ifTrue: [self cleanRule: (aRule members detect: [:m | m type ~= 'BLANK'])]
					ifFalse: [
						aRule
							at: 'members' put: (aRule members collect: [:m | self cleanRule: m]);
							yourself]].
			['SEQ'] -> [
				aRule
					at: 'members' put: (aRule members collect: [:m | self cleanRule: m]);
					yourself]}
		otherwise: [aRule]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> escapeStringForRegex: aString [

	^ aString copyWithRegex: '[.*+?^${}()|\[\]\\]' matchesTranslatedUsing: [:m | '\', m]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> fromSTType: aType [

	| block |
	block := SBMetaBlock new
		factory: self;
		symbols: #(nil nil);
		objectInterface: (aType at: #type).
	
	aType children notNil ifTrue: [
		aType children multiple
			ifTrue: [block childObjectInterface: (aType children types collect: #type)]
			ifFalse: [
				block addMorphBack: (SBMetaUnknown new
					objectInterfaces: (aType children types collect: #type);
					factory: self;
					yourself)]].
	
	(grammar rules at: (aType at: #type)) in: [:grammarRule |
		block symbols: (self symbolsForType: grammarRule).
		
		(grammarRule at: #type) = 'PATTERN' ifTrue: [block textFieldPattern: (grammarRule at: #value)].
		(grammarRule at: #type) = 'TOKEN' ifTrue: [block textFieldPattern: (self buildRegex: (grammarRule at: #content))].
		(grammarRule at: #type) = 'STRING' ifTrue: [block addMorphBack: (SBStringMorph new contents: (grammarRule at: #value))]].
	
	self orderedFieldsOf: aType do: [:fieldName | | field |
		field := aType fields at: fieldName.
		field multiple
			ifTrue: [
				block addMorphBack: (SBMetaBlock new
					factory: self;
					childObjectInterface: (field types collect: #type);
					objectInterface: '')]
			ifFalse: [
				(field types allSatisfy: [:t | t named not])
					ifTrue: [block textFieldPattern: ((field types collect: [:f | self escapeStringForRegex: (f at: #type)]) joinSeparatedBy: '|')]
					ifFalse: [
						block addMorphBack: (SBMetaUnknown new
							objectInterfaces: (field types collect: #type);
							factory: self;
							yourself)]]].
	
	^ block
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> fromTSRule: aRule [

	^ aRule type caseOf: {
		['SEQ'] -> [SBRow new addAllMorphs: (aRule members collect: [:m | self fromTSRule: m])].
		['STRING'] -> [SBStringMorph new contents: aRule value].
		['CHOICE'] -> [SBUnknown new]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> grammar: aString nodeTypes: anotherString [

	grammar := Json readFrom: aString readStream.
	nodeTypes := Json readFrom: anotherString readStream
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> orderedFieldsOf: aNode do: aBlock [

	| grammarRule |
	grammarRule := grammar rules at: aNode type.
	self
		visitTypeMembers: grammarRule
		do: [:member | member type = 'FIELD' ifTrue: [aBlock value: (member at: #name)]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> rule: aStringOrCollection triggersFor: aPrefixString do: aBlock [

	| rule type |
	aStringOrCollection isString ifFalse: [^ aStringOrCollection do: [:name | self rule: name triggersFor: aPrefixString do: aBlock]].
	
	rule := grammar rules at: aStringOrCollection.
	type := rule at: #type.
	
	(self unpackTypes includes: type) ifTrue: [^ (self token: rule content matches: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]].
	
	type caseOf: {
		['PATTERN'] -> [(aPrefixString matchesRegex: (rule at: #value)) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['CHOICE'] -> [rule members do: [:choice | (choice at: #type) = 'SYMBOL' ifTrue: [self rule: (choice at: #name) triggersFor: aPrefixString do: [:r :taken | aBlock value: r value: taken]]]].
		['TOKEN'] -> [((self buildRegex: rule) matchesPrefix: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['STRING'] -> [((rule at: #value) beginsWith: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['SEQ'] -> [(self token: rule members first matches: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> startsWithKeyword: anObject [

	^ anObject type
		caseOf: {
			['SEQ'] -> [self startsWithKeyword: anObject members first].
			['STRING'] -> [true]}
		otherwise: [false]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> symbolsForType: rule [

	(self unpackTypes includes: (rule at: #type)) ifTrue: [
		^ self symbolsForType: rule content].
	
	^ (rule at: #type) = 'SEQ'
		ifTrue: [
			{
				rule members first type = 'STRING'
					ifTrue: [rule members first at: #value]
					ifFalse: [nil].
				rule members last type = 'STRING'
					ifTrue: [rule members last at: #value]
					ifFalse: [nil]}]
		ifFalse: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> token: anObject matches: aString [

	^ self token: anObject matches: aString visited: OrderedCollection new
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> token: anObject matches: aString visited: aCollection [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [^ self token: (anObject at: #content) matches: aString visited: aCollection].
	
	^ (anObject at: #type) caseOf: {
		['STRING'] -> [(anObject at: #value) beginsWith: aString].
		['CHOICE'] -> [anObject members anySatisfy: [:c | self token: c matches: aString visited: aCollection]].
		['SEQ'] -> [self token: anObject members first matches: aString visited: aCollection].
		['PATTERN'] -> [aString matchesRegex: (anObject at: #value)].
		['BLANK'] -> [false].
		['SYMBOL'] -> [
			(aCollection includes: (anObject at: #name))
				ifTrue: [false]
				ifFalse: [
					aCollection add: (anObject at: #name).
					self token: (grammar rules at: (anObject at: #name)) matches: aString visited: aCollection]].
		['REPEAT'] -> [" TODO: can be optional, so just omit? "
		self token: anObject content matches: aString visited: aCollection].
		['REPEAT1'] -> [self token: anObject content matches: aString visited: aCollection]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unambiguousRule: aString for: aPrefixString do: aBlock [

	| candidates prefix matchFullToken |
	(matchFullToken := aPrefixString last = Character space)
		ifTrue: [prefix := aPrefixString allButLast]
		ifFalse: [prefix := aPrefixString].
	
	candidates := Array streamContents: [:stream | self rule: aString triggersFor: prefix do: [:b :keyWasTaken | stream nextPut: {b. keyWasTaken}]].
	
	candidates size = 1 ifTrue: [aBlock valueWithArguments: candidates first] ifFalse: [
		matchFullToken ifTrue: [
			candidates
				detect: [:c | self startsWithKeyword: (grammar rules at: c first)]
				ifFound: [:c | aBlock valueWithArguments: c]]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unpackTypes [

	^ #('PREC_RIGHT' 'PREC_LEFT' 'PREC_DYNAMIC' 'PREC' 'TOKEN' 'CONTENT' 'ALIAS' 'FIELD')
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> visitTypeMembers: anObject do: aBlock [

	anObject content ifNotNil: [:c |
		aBlock value: c.
		self visitTypeMembers: c do: aBlock].
	anObject members ifNotNil: [:members |
		members do: [:m |
			aBlock value: m.
			self visitTypeMembers: m do: aBlock]]
]
