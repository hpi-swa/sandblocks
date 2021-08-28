Class {
	#name : #SBMetaBlockFactory,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'nodeTypes',
		'slotMapping',
		'templateCache',
		'statementContainerTypes'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'grammar clean' }
SBMetaBlockFactory >> allSymbolsProducedBy: anObject on: aStream [

	(#('PREC' 'REPEAT' 'FIELD' 'REPEAT1') includes: anObject type) ifTrue: [^ self allSymbolsProducedBy: anObject content on: aStream].
	(#('STRING' 'PATTERN' 'BLANK') includes: anObject type) ifTrue: [^ self].
	
	anObject type caseOf: {
		['CHOICE'] -> [anObject members do: [:m | self allSymbolsProducedBy: m on: aStream]].
		['SYMBOL'] -> [aStream nextPut: anObject name].
		['ALIAS'] -> [aStream nextPut: anObject value].
		['SEQ'] -> [anObject members do: [:member | self allSymbolsProducedBy: member on: aStream]]}
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> applyInlining: rule [

	(rule type = 'SYMBOL' and: [
		(grammar inline includes: rule name) and: [
			SBToggledCode
				comment: ''
				active: 2
				do: {[true]. [(grammar supertypes includes: rule name) not]}]]) ifTrue: [ | inline symbols |
		inline := grammar rules at: rule name.
		rule name = 'expression_statement' ifTrue: [self halt].
		symbols := (Array streamContents: [:stream | self symbolsProducedBy: inline on: stream]) asSet.
		symbols size = 1 ifTrue: [rule name: symbols anyOne] ifFalse: [
			rule
				type: 'CHOICE';
				members: (symbols collect: [:m | JsonObject fromAssociations: {'name' -> m. 'type' -> 'SYMBOL'}] as: Array)].
		^ self].
	
	(rule type = 'SYMBOL' and: [rule name first = $_ and: [(grammar externals noneSatisfy: [:e | e name = rule name]) and: [(grammar supertypes includes: rule name) not]]]) ifTrue: [ | inline symbols |
		inline := grammar rules at: rule name.
		(self includesNonHiddenParts: inline visited: Set new) ifTrue: [
			symbols := (Array streamContents: [:stream | self allSymbolsProducedBy: inline on: stream]) asSet.
			rule removeAll.
			inline keysAndValuesDo: [:key :val | rule at: key put: val]].
		^ self].
	
	rule content ifNotNil: [:c | self applyInlining: c].
	rule members ifNotNil: [:c | c do: [:child | self applyInlining: child]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> at: aString putTemplate: aBlock [

	templateCache at: aString put: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> build: anObject in: aBlock slot: aSlot [

	aBlock factory: self parentSlot: aSlot.
	aBlock slot buildFor: aBlock.
	^ aBlock
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildBlocksFor: anObject parentFieldName: aString visitedSymbols: aSet [

	anObject type = 'FIELD' ifTrue: [^ self buildBlocksFor: anObject content parentFieldName: anObject name visitedSymbols: aSet].
	
	(self unpackTypes includes: anObject type) ifTrue: [^ self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet].
	
	(#('STRING') includes: anObject type) ifTrue: [
		^ SBInlineBlockLabel new
			label: anObject value;
			buildDefault].
	
	(#('PATTERN' 'TOKEN' 'IMMEDIATE_TOKEN') includes: anObject type) ifTrue: [
		^ SBInlineBlockText new
			regexString: (self buildRegexString: anObject);
			buildDefault].
	
	(#('SYMBOL') includes: anObject type) ifTrue: [
		^ SBInlineBlockSymbol new
			type: anObject name factory: self visitedSymbols: aSet;
			buildDefault].
	
	'REPEAT' = anObject type ifTrue: [
		^ SBInlineBlockRepeat new
			multiple: true
				required: false
				element: (self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet);
			buildDefault].
	
	'REPEAT1' = anObject type ifTrue: [
		^ SBInlineBlockRepeat new
			multiple: true
				required: true
				element: (self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet);
			buildDefault].
	
	'CHOICE' = anObject type ifTrue: [
		(anObject members size = 2 and: [anObject members second type = 'BLANK']) ifTrue: [
			^ SBInlineBlockRepeat new
				multiple: false
					required: false
					element: (self buildBlocksFor: anObject members first parentFieldName: aString visitedSymbols: aSet);
				buildDefault].
		
		^ SBInlineBlockChoice new
			alternatives: (anObject members collect: [:member | self buildBlocksFor: member parentFieldName: nil visitedSymbols: aSet]);
			buildDefault].
	
	'SEQ' = anObject type ifTrue: [^ SBInlineBlockSequence new elements: (anObject members collect: [:member | self buildBlocksFor: member parentFieldName: nil visitedSymbols: aSet])].
	
	self assert: false
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: rule [

	^ (self buildRegexString: rule) asRegex
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRegex: anObject on: aStream [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [^ self buildRegex: anObject content on: aStream].
	
	(anObject at: #type) caseOf: {
		['TOKEN'] -> [self buildRegex: anObject content on: aStream].
		['IMMEDIATE_TOKEN'] -> [self buildRegex: anObject content on: aStream].
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
SBMetaBlockFactory >> buildRegexString: rule [

	| s |
	s := '' writeStream.
	self buildRegex: rule on: s.
	^ (s contents copyReplaceAll: '\p{XID_Start}' with: 'A-Za-z')
		copyReplaceAll: '\p{XID_Continue}'
		with: 'A-Za-z0-9'
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildRule: aType [

	^ self
		build: (grammar rules at: aType ifAbsent: [self assert: false])
		in: SBMetaBlock new
		slot: (SBMetaSlotBlock topLevel: aType factory: self)
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> buildSlotsFor: anObject parentFieldName: aString [

	anObject type = 'FIELD' ifTrue: [^ self buildSlotsFor: anObject content parentFieldName: anObject name].
	
	(self unpackTypes includes: anObject type) ifTrue: [^ self buildSlotsFor: anObject content parentFieldName: aString].
	
	(#('STRING') includes: anObject type) ifTrue: [
		^ SBMetaSlotLabel new
			name: aString;
			label: anObject value].
	
	(#('PATTERN' 'TOKEN') includes: anObject type) ifTrue: [
		^ SBMetaSlotText new
			name: aString;
			regexString: (self buildRegexString: anObject)].
	
	(#('SYMBOL') includes: anObject type) ifTrue: [
		^ SBMetaSlotBlock new
			name: aString;
			type: anObject name factory: self].
	
	'REPEAT' = anObject type ifTrue: [
		^ (SBMetaSlotRepeat new element: (self buildSlotsFor: anObject content parentFieldName: aString))
			multiple: true;
			required: false].
	
	'REPEAT1' = anObject type ifTrue: [
		^ (SBMetaSlotRepeat new element: (self buildSlotsFor: anObject content parentFieldName: aString))
			multiple: true;
			required: true].
	
	'CHOICE' = anObject type ifTrue: [
		(anObject members size = 2 and: [anObject members second type = 'BLANK']) ifTrue: [
			^ (SBMetaSlotRepeat new element: (self buildSlotsFor: anObject members first parentFieldName: aString))
				multiple: false;
				required: false].
		
		^ SBMetaSlotChoice new
			name: aString;
			alternatives: (anObject members collect: [:member | self buildSlotsFor: member parentFieldName: nil])].
	
	'SEQ' = anObject type ifTrue: [
		^ SBMetaSlotGroup new
			name: aString;
			elements: (anObject members collect: [:member | self buildSlotsFor: member parentFieldName: nil])].
	
	self assert: false
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> cleanGrammar [

	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeExternals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self simplifyList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules keysAndValuesDo: [:name :rule | self flattenSeparatedList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules keysAndValuesDo: [:name :rule | self applyInlining: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRedundantRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeAliases: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeOptionalRepeat: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeDuplicateAlternatives: rule]]}
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> deepCompare: anObject to: anotherObject [

	anObject associationsDo: [:assoc | | obj |
		obj := anotherObject at: assoc key ifAbsent: [^ false].
		((obj isDictionary and: [assoc value isDictionary])
			ifTrue: [self deepCompare: assoc value to: obj]
			ifFalse: [obj = assoc value]) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> escapeStringForRegex: aString [

	^ aString copyWithRegex: '[.*+?^${}()|\[\]\\]' matchesTranslatedUsing: [:m | '\', m]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> fieldsOf: aRule [

	^ nodeTypes detect: [:t | t type = aRule] ifFound: [:t | t fields collect: #type]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> flattenSeparatedList: anObject [

	| looksLikeSepList looksLikeOptionalSep |
	looksLikeSepList := [:obj | obj type = 'SEQ' and: [obj members size = 2 and: [obj members second type = 'REPEAT' and: [obj members second content type = 'SEQ' and: [self deepCompare: obj members first to: obj members second content members second]]]]].
	looksLikeOptionalSep := [:obj | obj type = 'CHOICE' and: [obj members second type = 'BLANK' and: [obj members first type = 'STRING']]].
	
	" seq(seq(rule, repeat(seq(separator, rule))), (separator|blank)) "
	(anObject type = 'SEQ' and: [(looksLikeSepList value: anObject members first) and: [looksLikeOptionalSep value: anObject members second]]) ifTrue: [
		^ anObject
			type: 'REPEAT';
			content: anObject members first members first;
			removeKey: #members].
	
	" seq(rule, repeat(seq(separator, rule))) "
	(looksLikeSepList value: anObject) ifTrue: [
		^ anObject
			type: 'REPEAT';
			content: anObject members first;
			removeKey: #members].
	
	anObject content ifNotNil: [:c | self flattenSeparatedList: c].
	anObject members ifNotNil: [:c | c do: [:m | self flattenSeparatedList: m]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> fromTSRule: aRule [

	^ aRule type caseOf: {
		['SEQ'] -> [SBRow new addAllMorphs: (aRule members collect: [:m | self fromTSRule: m])].
		['STRING'] -> [SBStringMorph new contents: aRule value].
		['CHOICE'] -> [SBUnknown new]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> getTemplate: aString [

	^ self getTemplate: aString visitedSymbols: Set new
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> getTemplate: aTypeString visitedSymbols: aSet [

	^ templateCache at: aTypeString ifAbsent: [
		" reserve spot in case of recursion "
		templateCache at: aTypeString put: nil.
		templateCache at: aTypeString put: (SBToggledCode comment: '' active: 2 do: {
			[
				SBInlineBlockSymbol new type: aTypeString factory: self block: (self
					buildBlocksFor: (grammar rules at: aTypeString ifAbsent: [self assert: false])
					parentFieldName: nil
					visitedSymbols: aSet)].
			[
				self
					buildBlocksFor: (grammar rules at: aTypeString ifAbsent: [self assert: false])
					parentFieldName: nil
					visitedSymbols: aSet]})]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> grammar [

	^ grammar
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> grammar: aString nodeTypes: anotherString [

	grammar := Json readFrom: aString readStream.
	nodeTypes := Json readFrom: anotherString readStream
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> includesNonHiddenParts: anObject visited: aCollection [

	(#('PREC' 'PREC_DYNAMIC' 'PREC_LEFT' 'PREC_RIGHT' 'REPEAT' 'FIELD' 'REPEAT1') includes: anObject type) ifTrue: [^ self includesNonHiddenParts: anObject content visited: aCollection].
	(#('STRING' 'PATTERN' 'BLANK' 'TOKEN') includes: anObject type) ifTrue: [^ false].
	
	^ anObject type caseOf: {
		['CHOICE'] -> [anObject members anySatisfy: [:m | self includesNonHiddenParts: m visited: aCollection]].
		['SYMBOL'] -> [
			anObject name first ~= $_ ifTrue: [^ true].
			(aCollection includes: anObject name) ifTrue: [false] ifFalse: [
				aCollection add: anObject name.
				self includesNonHiddenParts: (grammar rules at: anObject name) visited: aCollection]].
		['ALIAS'] -> [
			anObject value first ~= $_ ifTrue: [^ true].
			(aCollection includes: anObject value) ifTrue: [false] ifFalse: [
				aCollection add: anObject value.
				grammar rules
					at: anObject value
					ifPresent: [:r | self includesNonHiddenParts: r visited: aCollection]
					ifAbsent: [false]]].
		['SEQ'] -> [anObject members anySatisfy: [:member | self includesNonHiddenParts: member visited: aCollection]]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> initialize [

	super initialize.
	
	slotMapping := Dictionary new.
	templateCache := Dictionary new.
	statementContainerTypes := {}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> instantiateTemplate: aString [

	^ (self getTemplate: aString) buildEmpty buildDefault
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> instantiateToplevel: aString [

	^ SBInlineBlockSymbol new
		type: aString
		factory: self
		block: (self instantiateTemplate: aString)
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> isStatementContainer: aString [

	^ statementContainerTypes includes: aString
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> isSuperType: aTypeString [

	^ grammar supertypes includes: aTypeString
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeOptionalRepeat: anObject [

	(anObject type = 'CHOICE' and: [anObject members size = 2 and: [(anObject members first type beginsWith: 'REPEAT') and: [anObject members second type = 'BLANK']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
		anObject type: 'REPEAT'].
	
	anObject content ifNotNil: [:c | self mergeOptionalRepeat: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeOptionalRepeat: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeRedundantRepeats: anObject [

	(anObject type = 'REPEAT' and: [anObject content type = 'CHOICE']) ifTrue: [
		anObject content members do: [:m |
			(m type = 'REPEAT' or: [m type = 'REPEAT1']) ifTrue: [ | copyFrom |
				copyFrom := m content.
				m removeAll.
				copyFrom keysAndValuesDo: [:key :val | m at: key put: val]]]].
	
	anObject content ifNotNil: [:c | self mergeRedundantRepeats: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeRedundantRepeats: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeRepeats: anObject [

	(anObject type = 'SEQ' and: [anObject members size = 2 and: [anObject members first type = 'SYMBOL' and: [(anObject members last type = 'REPEAT' and: [anObject members last content type = 'SYMBOL']) and: [anObject members last content name = anObject members first name]]]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members last.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
		anObject type: 'REPEAT1'].
	
	
	anObject content ifNotNil: [:c | self mergeRepeats: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeRepeats: m]]
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

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeAliases: anObject [

	anObject type = 'ALIAS' ifTrue: [
		anObject type: 'SYMBOL'.
		anObject name: anObject value.
		anObject removeKey: 'value'.
		anObject removeKey: 'named'.
		anObject removeKey: 'content'.
		^ self].
	
	anObject content ifNotNil: [:c | self removeAliases: c].
	anObject members ifNotNil: [:c | c do: [:m | self removeAliases: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeDuplicateAlternatives: anObject [
	" TODO: only removes SYMBOL duplicates "

	(anObject type = 'CHOICE' and: [anObject members allSatisfy: [:m | m type = 'SYMBOL']]) ifTrue: [ | symbols |
		symbols := anObject members collect: #name.
		symbols size ~= symbols asSet size ifTrue: [
			anObject members: anObject members withoutDuplicates]].
	anObject content ifNotNil: [self removeDuplicateAlternatives: anObject content].
	anObject members ifNotNil: [anObject members do: [:m | self removeDuplicateAlternatives: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeExternals: anObject [

	anObject content ifNotNil: [:c | self removeExternals: c].
	anObject members ifNotNil: [
		anObject members: (anObject members copyWithoutAll: (Array streamContents: [:stream | anObject members do: [:member | (member type = 'SYMBOL' and: [grammar externals anySatisfy: [:external | external name = member name]]) ifTrue: [stream nextPut: member]]])).
		anObject members do: [:m | self removeExternals: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeHiddenTerminals: anObject [

	anObject content ifNotNil: [:c | self removeHiddenTerminals: c].
	anObject members ifNotNil: [
		anObject members: (anObject members copyWithoutAll: (Array streamContents: [:stream | anObject members do: [:member | ((member type = 'SYMBOL' and: [(self includesNonHiddenParts: member visited: Set new) not]) or: [anObject type = 'SEQ' and: [member type = 'BLANK']]) ifTrue: [stream nextPut: member]]])).
		anObject members do: [:m | self removeHiddenTerminals: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeOptionalString: aString in: anObject [

	(anObject type = 'SEQ' and: [
		anObject members last type = 'CHOICE' and: [ | choices |
			choices := anObject members last members.
			choices size = 2 and: [choices second type = 'BLANK' and: [choices first type = 'STRING' and: [choices first value = aString]]]]]) ifTrue: [
		anObject members size = 2
			ifTrue: [anObject members last members: (anObject members last members copyWithout: anObject members last members last)]
			ifFalse: [ | copyFrom |
				copyFrom := anObject members first.
				anObject removeAll.
				copyFrom keysAndValuesDo: [:key :value | anObject at: key put: value]]].
	anObject content ifNotNil: [:c | self removeOptionalString: aString in: c].
	anObject members ifNotNil: [:c | c do: [:m | self removeOptionalString: aString in: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> rule: aRule inlineIn: anObject [

	(anObject type = 'SYMBOL' and: [anObject name = aRule]) ifTrue: [ | copyFrom |
		copyFrom := grammar rules at: aRule.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val veryDeepCopy].
		^ self].
	
	anObject content ifNotNil: [:c | self rule: aRule inlineIn: c].
	anObject members ifNotNil: [anObject members do: [:m | self rule: aRule inlineIn: m]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> rule: aSlot triggersFor: aPrefixString do: aBlock [

	self
		token: aSlot structure
		matches: aPrefixString
		visited: OrderedCollection new
		parent: aSlot
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
SBMetaBlockFactory >> shouldBlockInline: aTypeString [

	^ (self isSuperType: aTypeString) or: [self grammar blockInline ifNotNil: [:i | i includes: aTypeString] ifNil: [false]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> simplifyGrammar [

	
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeExternals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self simplifyList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self flattenSeparatedList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules keysAndValuesDo: [:name :rule | self applyInlining: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRedundantRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeAliases: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeOptionalRepeat: rule]]}
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> simplifyList: anObject [

	(anObject type = 'CHOICE' and: [anObject members size = 2 and: [anObject members last type = 'BLANK' and: [anObject members first type = 'REPEAT']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val]].
	
	anObject content ifNotNil: [:c | self simplifyList: c].
	anObject members ifNotNil: [anObject members do: [:m | self simplifyList: m]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> slotsFor: aString [

	^ slotMapping at: aString ifAbsentPut: [
		(self buildSlotsFor: (grammar rules at: aString ifAbsent: [self assert: false]) parentFieldName: nil)
			isRoot: true;
			yourself]
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
SBMetaBlockFactory >> statementContainerTypes: aCollection [

	statementContainerTypes := aCollection
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

{ #category : #'grammar clean' }
SBMetaBlockFactory >> symbolsProducedBy: anObject on: aStream [

	(#('PREC') includes: anObject type) ifTrue: [^ self symbolsProducedBy: anObject content on: aStream].
	
	anObject type caseOf: {
		['CHOICE'] -> [anObject members do: [:m | self symbolsProducedBy: m on: aStream]].
		['SYMBOL'] -> [aStream nextPut: anObject name].
		['ALIAS'] -> [aStream nextPut: anObject value].
		['SEQ'] -> [ | nonHidden |
			self assert: (anObject members allSatisfy: [:m | m type = 'SYMBOL']).
			nonHidden := anObject members select: [:m | m name first ~= $_].
			self assert: nonHidden size = 1.
			aStream nextPut: nonHidden first name value]}
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
SBMetaBlockFactory >> token: anObject matches: aString visited: aCollection parents: aRuleCollection matchDo: aBlock [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [
		^ self
			token: (anObject at: #content)
			matches: aString
			visited: aCollection
			parents: aRuleCollection
			matchDo: aBlock].
	
	(anObject at: #type) caseOf: {
		['STRING'] -> [((anObject at: #value) beginsWith: aString) ifTrue: [aBlock value: aRuleCollection value: true]].
		['CHOICE'] -> [anObject members do: [:c | self token: c matches: aString visited: aCollection parents: aRuleCollection matchDo: aBlock]].
		['SEQ'] -> [
			self
				token: anObject members first
				matches: aString
				visited: aCollection
				parents: aRuleCollection
				matchDo: aBlock].
		['PATTERN'] -> [((self buildRegex: anObject) matches: aString) ifTrue: [aBlock value: aRuleCollection value: false]].
		['BLANK'] -> [].
		['TOKEN'] -> [((self buildRegex: anObject) matches: aString) ifTrue: [aBlock value: aRuleCollection value: false]].
		['SYMBOL'] -> [
			(aCollection includes: (anObject at: #name)) ifFalse: [
				aCollection add: (anObject at: #name).
				grammar rules at: (anObject at: #name) ifPresent: [:rule |
					self
						token: rule
						matches: aString
						visited: aCollection
						parents: aRuleCollection, {anObject at: #name}
						matchDo: aBlock]]].
		['REPEAT'] -> [
			" TODO: can be optional, so just omit? "
			self
				token: anObject content
				matches: aString
				visited: aCollection
				parents: aRuleCollection
				matchDo: aBlock].
		['REPEAT1'] -> [
			self
				token: anObject content
				matches: aString
				visited: aCollection
				parents: aRuleCollection
				matchDo: aBlock]}
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> type: aRuleName compatibleWith: anotherRuleName [

	(aRuleName isNil and: [anotherRuleName isNil]) ifTrue: [^ true].
	
	anotherRuleName isString ifFalse: [^ anotherRuleName anySatisfy: [:r | self type: aRuleName compatibleWith: r]].
	
	SBToggledCode comment: '' active: 0 do: {
		[[(grammar supertypes includes: anotherRuleName) and: [((grammar rules at: anotherRuleName) members collect: #name) includes: aRuleName]]]}.
	^ aRuleName = anotherRuleName or: [
		(nodeTypes detect: [:t | t type = anotherRuleName] ifNone: [^ false]) subtypes
			ifNotNil: [:types | types anySatisfy: [:t | self type: aRuleName compatibleWith: t type]]
			ifNil: [false]]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unambiguousRule: aSlot for: aPrefixString do: aBlock [

	| prefix matchFullToken options |
	(matchFullToken := aPrefixString last = Character space)
		ifTrue: [prefix := aPrefixString allButLast]
		ifFalse: [prefix := aPrefixString].
	
	options := SBTSPartialNode new.
	
	aSlot triggersFor: prefix matchFullToken: matchFullToken do: options.
	
	options size = 1 ifTrue: [ | morph |
		morph := SBMetaBlock new factory: self parentSlot: aSlot.
		aSlot buildPartialFor: morph option: options children first with: aPrefixString.
		" FIXME: is this correct? "
		aBlock value: (morph submorphCount = 1 ifTrue: [morph firstSubmorph] ifFalse: [morph])]
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unknownFor: aSlot [

	^ SBMetaUnknown new
		slot: aSlot;
		factory: self;
		yourself
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unpackFieldForSlot: anObject fieldName: aString do: aBlock [

	anObject type = 'FIELD' ifTrue: [^ aBlock value: anObject content value: anObject name].
	
	^ aBlock value: anObject value: aString
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactory >> unpackTypes [

	^ #('PREC_RIGHT' 'PREC_LEFT' 'PREC_DYNAMIC' 'PREC' 'ALIAS' 'FIELD')
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> unwrapSingleChoices: anObject [

	(((anObject type = 'CHOICE' or: [anObject type = 'SEQ']) and: [anObject members size = 1]) or: [anObject type = 'CHOICE' and: [anObject members size = 2 and: [anObject members first type = 'REPEAT' and: [anObject members second type = 'BLANK']]]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val]].
	
	anObject content ifNotNil: [:c | self unwrapSingleChoices: c].
	anObject members ifNotNil: [anObject members do: [:m | self unwrapSingleChoices: m]]
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
