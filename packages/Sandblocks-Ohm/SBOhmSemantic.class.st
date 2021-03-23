Class {
	#name : #SBOhmSemantic,
	#superclass : #OhmSemanticAction,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Alt: aNode alt: alt [

	| obj |
	obj := self value: alt.
	^ SBOhmList new
		connect: 'OR' expressions: (obj isCollection ifTrue: [obj] ifFalse: [{obj}]);
		maybeUnwrapList
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> AltRec: aNode term: term pipe: pipe alt: alt [

	| rec |
	rec := self value: alt.
	
	^ SBOhmList new
		connect: 'OR' expressions: {self value: term}, (rec isAlternative ifTrue: [rec expressions] ifFalse: [{rec}]);
		maybeUnwrapList
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Base: aNode base: base [

	^ self value: base
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> BaseApplication: aNode identifier: identifier params: params [

	^ SBOhmIdentifier new contents: aNode interval contents
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> BaseParen: node with: x with: expr with: xx [

	^ self value: expr
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> BaseTerminal: aNode terminal: terminal [

	^ self value: terminal
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Grammar: aNode header: header open: x rules: rules close: xx [

	^ SBOhmGrammar new
		addAllMorphs: (
			rules children collect: [:rule |
				self value: rule])
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Iter: aNode pred: pred [

	^ self value: pred
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> IterOpt: node with: expr with: x [

	^ SBOhmQuantifier new expression: (self value: expr) quantifier: $?
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> IterPlus: node with: expr with: x [

	^ SBOhmQuantifier new expression: (self value: expr) quantifier: $+
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> IterStar: node with: expr with: x [

	^ SBOhmQuantifier new expression: (self value: expr) quantifier: '*'
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Lex: aNode base: base [

	^ self value: base
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Pred: aNode lex: lex [

	^ self value: lex
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> PredLookahead: node with: x with: expr [

	^ SBOhmPredicate new expression: (self value: expr) predicate: '&'
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> PredNot: node with: x with: expr [

	^ SBOhmPredicate new expression: (self value: expr) predicate: '~'
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Rule: aNode rule: rule [

	^ self value: rule
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> RuleDefine: aNode identifier: identifier formals: formals ruleDescription: ruleDescription assignment: assignment alternative: alternative [

	^ SBOhmRule new name: identifier interval contents alternatives: (self value: alternative)
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> RuleExtend: node with: name with: parameters with: x with: body [

	^ SBOhmRule new name: name interval contents alternatives: (self value: body)
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Seq: aNode iter: iter [

	^ SBOhmList new
		connect: 'AND' expressions: (iter children collect: [:c | self value: c]);
		maybeUnwrapList
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> Term: aNode term: aTerm [

	^ self value: aTerm
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> TermInline: node with: expr with: name [

	^ self value: expr
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> ohmTerminal: aNode terminal: terminal [

	^ self value: terminal
]

{ #category : #'as yet unclassified' }
SBOhmSemantic >> string: aNode open: x chars: chars close: xx [

	^ SBOhmTerminal new contents: aNode interval contents viewAllButFirstAndLast
]
