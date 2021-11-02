Class {
	#name : #SBGrammarLanguage,
	#superclass : #SBMetaBlockFactory,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> grammarJson [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> highlightQuery [

	^ nil
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> language [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> parse: aString [

	^ self new parse: aString
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> rootRuleName [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> statementContainerTypes [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage class >> toplevel [

	^ self new toplevel
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage >> configure [
	" entry point for calling configuration methods on the processed grammar, e.g. blockInline:, or delimitedRules: "

	
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage >> initialize [

	super initialize.
	
	grammar := Json readFrom: self class grammarJson readStream.
	supertypes := grammar supertypes.
	name := self class language.
	highlightQuery := self class highlightQuery ifNotNil: [:query | SBTSQuery new prepare: query].
	extras := grammar extras
		select: [:rule | rule type = 'SYMBOL']
		thenCollect: [:rule | rule name].
	
	self wordRule: grammar word.
	self rootRuleName: self class rootRuleName.
	self statementContainerTypes: self class statementContainerTypes.
	
	self preprocessGrammar.
	self cleanGrammar.
	self configure.
	
	" make sure all rules are in the cache "
	grammar rules keysAndValuesDo: [:name :r | self getTemplate: name]
]

{ #category : #'as yet unclassified' }
SBGrammarLanguage >> preprocessGrammar [
	" entrypoint to clean the grammar before the automated steps happen, e.g. replacing or removing external rules "

	
]
