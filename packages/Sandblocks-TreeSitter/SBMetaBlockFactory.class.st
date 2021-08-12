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
SBMetaBlockFactory >> addMorphsFor: anObject to: aBlock parentField: aString withValues: aDictionary [

	'FIELD' = anObject type ifTrue: [^ self addMorphsFor: anObject content to: aBlock parentField: anObject name withValues: aDictionary].
	
	(self unpackTypes includes: anObject type) ifTrue: [^ self addMorphsFor: anObject content to: aBlock parentField: aString withValues: aDictionary].
	
	(#('SYMBOL' 'REPEAT1') includes: anObject type) ifTrue: [^ aBlock addMorphBack: (aDictionary at: aString ifAbsent: [self unknownFor: anObject name])].
	
	(#('TOKEN' 'PATTERN') includes: anObject type) ifTrue: [
		self assert: aBlock textFieldPattern isNil.
		^ aBlock textFieldPattern: (self buildRegex: anObject)].
	
	anObject type caseOf: {
		['STRING'] -> [aBlock addMorphBack: (SBStringMorph new contents: anObject value)].
		['REPEAT'] -> [
			aDictionary
				at: aString
				ifPresent: [:f | aBlock addMorphBack: f]
				ifAbsent: [self unknownFor: anObject name]].
		['CHOICE'] -> [
			(anObject members size = 2 and: [anObject members contains: [:m | m type = 'BLANK']])
				ifTrue: [" optional, don't have to add anything "
				]
				ifFalse: [" FIXME: wrong assumption "
				self addMorphsFor: anObject members first to: aBlock parentField: aString withValues: aDictionary]].
		['SEQ'] -> [anObject members do: [:m | self addMorphsFor: m to: aBlock parentField: aString withValues: aDictionary]]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> build: aType [

	^ self build: aType in: SBMetaBlock new withValues: Dictionary new
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> build: aType in: aBlock withValues: aDictionary [

	| grammarRule |
	aBlock
		factory: self;
		symbols: #(nil nil);
		objectInterface: aType;
		grammarRule: (grammarRule := grammar rules at: aType).
	
	self addMorphsFor: grammarRule to: aBlock parentField: nil withValues: aDictionary.
	
	^ aBlock
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: rule [

	| s |
	s := '' writeStream.
	self buildRegex: rule on: s.
	^ ((s contents copyReplaceAll: '\p{XID_Start}' with: 'A-Za-z')
		copyReplaceAll: '\p{XID_Continue}'
		with: 'A-Za-z0-9') asRegex
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: anObject on: aStream [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [^ self buildRegex: anObject content on: aStream].
	
	(anObject at: #type) caseOf: {
		['TOKEN'] -> [self buildRegex: anObject content on: aStream].
		['REPEAT'] -> [
			self buildRegex: anObject content on: aStream.
			aStream nextPut: $*].
		['REPEAT1'] -> [
			self buildRegex: anObject content on: aStream.
			aStream nextPut: $+].
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
SBMetaBlockFactory >> buildSlotsFor: anObject [

	^ SBMetaSlotArray new
		slots: (Array streamContents: [:stream | self buildSlotsFor: anObject parentFieldName: nil on: stream]);
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildSlotsFor: anObject parentFieldName: aString on: aStream [

	anObject type = 'FIELD' ifTrue: [^ self buildSlotsFor: anObject content parentFieldName: anObject name on: aStream].
	
	(self unpackTypes includes: anObject type) ifTrue: [^ self buildSlotsFor: anObject content parentFieldName: aString on: aStream].
	
	(#('STRING' 'PATTERN' 'TOKEN' 'SYMBOL') includes: anObject type) ifTrue: [^ aStream nextPut: ((SBMetaSlot one type: anObject) name: aString)].
	
	(#('REPEAT' 'REPEAT1') includes: anObject type) ifTrue: [
		^ aStream nextPut: (self
			unpackFieldForSlot: anObject content
			fieldName: aString
			do: [:symbol :field | ((SBMetaSlot perform: (anObject type = 'REPEAT' ifTrue: [#any] ifFalse: [#atLeastOne])) type: symbol) name: field])].
	
	anObject type caseOf: {
		['CHOICE'] -> [
			" pattern for optional structure "
			(anObject members size = 2 and: [anObject members second type = 'BLANK']) ifTrue: [
				^ aStream nextPut: (self
					unpackFieldForSlot: anObject members first
					fieldName: aString
					do: [:symbol :field | (SBMetaSlot optional type: symbol) name: field])].
			
			" FIXME: most-often incorrect guess that the structure of all members is the same "
			self buildSlotsFor: anObject members first parentFieldName: aString on: aStream].
		['SEQ'] -> [anObject members do: [:m | self buildSlotsFor: m parentFieldName: aString on: aStream]]}
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
SBMetaBlockFactory >> oldFromSTType: aType withValues: aDictionary [

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
					ifTrue: [
						block textFieldPattern: ((field types collect: [:f | self escapeStringForRegex: (f at: #type)]) joinSeparatedBy: '|').
						aDictionary at: fieldName ifPresent: [:val | block contents: val]]
					ifFalse: [
						block addMorphBack: (aDictionary at: fieldName ifPresent: [:val | val] ifAbsent: [
							SBMetaUnknown new
								objectInterfaces: (field types collect: #type);
								factory: self;
								yourself])]]].
	
	^ block
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> oldrule: aStringOrCollection triggersFor: aPrefixString do: aBlock [

	| rule type |
	aStringOrCollection isString ifFalse: [^ aStringOrCollection do: [:name | self rule: name triggersFor: aPrefixString do: aBlock]].
	
	rule := grammar rules at: aStringOrCollection.
	type := rule at: #type.
	
	(self unpackTypes includes: type) ifTrue: [
		^ self
			token: rule content
			matches: aPrefixString
			matchDo: [aBlock value: aStringOrCollection value: false]].
	
	type caseOf: {
		['PATTERN'] -> [(aPrefixString matchesRegex: (rule at: #value)) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['CHOICE'] -> [rule members do: [:choice | (choice at: #type) = 'SYMBOL' ifTrue: [self rule: (choice at: #name) triggersFor: aPrefixString do: [:r :taken | aBlock value: r value: taken]]]].
		['TOKEN'] -> [((self buildRegex: rule) matchesPrefix: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['STRING'] -> [((rule at: #value) beginsWith: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]].
		['SEQ'] -> [(self token: rule members first matches: aPrefixString) ifTrue: [aBlock value: aStringOrCollection value: false]]}
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

	| rule |
	aStringOrCollection isString ifFalse: [^ aStringOrCollection do: [:name | self rule: name triggersFor: aPrefixString do: aBlock]].
	
	rule := grammar rules at: aStringOrCollection.
	
	self
		token: rule
		matches: aPrefixString
		visited: OrderedCollection new
		parent: aStringOrCollection
		matchDo: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> rulesMatching: aStringOrCollection containing: aRuleName forPrefix: aPrefixString do: aBlock [

	| rule |
	aStringOrCollection isString ifFalse: [^ aStringOrCollection do: [:name | self rulesMatching: name containing: aRuleName forPrefix: aPrefixString do: aBlock]].
	
	rule := nodeTypes detect: [:t | t type = aStringOrCollection].
	rule
		at: #subtypes
		ifPresent: [:subtypes | ^ subtypes do: [:t | self rulesMatching: t type containing: aRuleName forPrefix: aPrefixString do: aBlock]].
	
	rule fields ifNotNil: [:fields |
		fields keysAndValuesDo: [:name :f |
			(f types anySatisfy: [:t | self type: aRuleName compatibleWith: t type]) ifTrue: [
				fields associations
					detect: [:operatorField | operatorField value ~= f and: [operatorField value types anySatisfy: [:op | op named not and: [op type beginsWith: aPrefixString]]]]
					ifFound: [:operatorField | aBlock value: rule value: name value: operatorField key]]]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> startsWithKeyword: anObject [

	(self unpackTypes includes: anObject type) ifTrue: [^ self startsWithKeyword: anObject content].
	
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
SBMetaBlockFactory >> token: anObject matches: aString visited: aCollection parent: aRuleName matchDo: aBlock [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [
		^ self
			token: (anObject at: #content)
			matches: aString
			visited: aCollection
			parent: aRuleName
			matchDo: aBlock].
	
	(anObject at: #type) caseOf: {
		['STRING'] -> [((anObject at: #value) beginsWith: aString) ifTrue: [aBlock value: aRuleName value: true]].
		['CHOICE'] -> [anObject members do: [:c | self token: c matches: aString visited: aCollection parent: aRuleName matchDo: aBlock]].
		['SEQ'] -> [self token: anObject members first matches: aString visited: aCollection parent: aRuleName matchDo: aBlock].
		['PATTERN'] -> [((self buildRegex: anObject) matches: aString) ifTrue: [aBlock value: aRuleName value: false]].
		['BLANK'] -> [].
		['TOKEN'] -> [((self buildRegex: anObject) matches: aString) ifTrue: [aBlock value: aRuleName value: false]].
		['SYMBOL'] -> [
			(aCollection includes: (anObject at: #name)) ifFalse: [
				aCollection add: (anObject at: #name).
				grammar rules
					at: (anObject at: #name)
					ifPresent: [:rule | self token: rule matches: aString visited: aCollection parent: (anObject at: #name) matchDo: aBlock]]].
		['REPEAT'] -> [" TODO: can be optional, so just omit? "
		self token: anObject content matches: aString visited: aCollection parent: aRuleName matchDo: aBlock].
		['REPEAT1'] -> [self token: anObject content matches: aString visited: aCollection parent: aRuleName matchDo: aBlock]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> type: aRuleName compatibleWith: anotherRuleName [

	SBToggledCode comment: '' active: 0 do: {
		[[(grammar supertypes includes: anotherRuleName) and: [((grammar rules at: anotherRuleName) members collect: #name) includes: aRuleName]]]}.
	^ aRuleName = anotherRuleName or: [
		(nodeTypes detect: [:t | t type = anotherRuleName] ifNone: [^ false]) subtypes
			ifNotNil: [:types | types anySatisfy: [:t | self type: aRuleName compatibleWith: t type]]
			ifNil: [false]]
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
SBMetaBlockFactory >> unknownFor: aCollection [

	^ SBMetaUnknown new
		objectInterfaces: aCollection;
		factory: self;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unpackFieldForSlot: anObject fieldName: aString do: aBlock [

	^ anObject type = 'FIELD'
		ifTrue: [
			self assert: anObject content type = 'SYMBOL'.
			aBlock value: anObject content value: anObject name]
		ifFalse: [
			self assert: anObject type = 'SYMBOL'.
			aBlock value: anObject value: aString]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unpackTypes [

	^ #('PREC_RIGHT' 'PREC_LEFT' 'PREC_DYNAMIC' 'PREC' 'CONTENT' 'ALIAS' 'FIELD')
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
