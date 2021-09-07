Class {
	#name : #SBGrammarSimplify,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'postDo',
		'preDo',
		'isOhm'
	],
	#category : #'Sandblocks-Kogi'
}

{ #category : #accessing }
SBGrammarSimplify >> grammar [

	^ grammar
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> grammar: aStringOrGrammar [

	grammar := SBOhmGrammar from: aStringOrGrammar
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> initialize [

	preDo := [:grammar | ].
	postDo := [:grammar | ].
	isOhm := false
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> isOhm: aBoolean [

	isOhm := aBoolean
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> postDo: aBlock [

	postDo := aBlock
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> preDo: aBlock [

	preDo := aBlock
]

{ #category : #'as yet unclassified' }
SBGrammarSimplify >> simplifyAndOpen [

	| originalGrammar |
	preDo value: grammar.
	
	isOhm ifTrue: [grammar := SBGrammarTransformer run: SBGrammarTransformer ohmToRascal for: grammar].
	grammar := SBGrammarTransformer
		run: SBGrammarTransformer removeUnnecessarySyntax
		for: grammar.
	originalGrammar := grammar veryDeepCopy.
	grammar := SBGrammarTransformer
		run: SBGrammarTransformer rascalSimplifiedMin
		for: grammar.
	
	postDo value: grammar.
	
	SBToggledCode comment: '' active: 1 do: {[grammar openInHand]}.
	grammar openBlocklyFrom: originalGrammar
]
