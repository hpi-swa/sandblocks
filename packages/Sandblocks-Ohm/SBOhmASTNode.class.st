Class {
	#name : #SBOhmASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmASTNode class >> registerShortcuts: aProvider [

	aProvider
		cmdShortcut: $+ do: #wrapInPlus;
		cmdShortcut: $* do: #wrapInStar;
		cmdShortcut: $? do: #wrapInOptional;
		cmdShortcut: $| do: #wrapInAlternative
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> actionProviders [

	^ {self grammarHandler. self}
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> containingRule [

	^ self parentSandblock containingRule
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> grammarHandler [

	^ SBOhmGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> initialize [

	super initialize.
		
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isAlternative [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isIdentifier [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isLookahead [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isOhm [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isOptional [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isQuantifier [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isRepeatQuantifier [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isRule [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isSequence [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isTerminal [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isTerminalish [

	^ self isTerminal
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> maybeUnwrapList [

	^ self
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> mergeRedundantGroups [
	" flatten AND and OR sequences that only contain one child and nested quantifiers "

	self allBlocksDo: [:b |
		(((b isAlternative or: [b isSequence]) and: [b childSandblocks size <= 1 or: [(b isAlternative and: [b parentSandblock isAlternative]) or: [b isSequence and: [b parentSandblock isSequence]]]]) and: [(b valueOfProperty: #pinned ifAbsent: [false]) not]) ifTrue: [
			b flattenChildren.
			" to make sure we don't operate on an invalid tree, start over "
			^ self mergeRedundantGroups].
		(b isQuantifier and: [b quantifier = $? and: [b expression isQuantifier and: [b expression quantifier = $+]]]) ifTrue: [
			b expression quantifier: $*.
			b replaceBy: b expression]]
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> object [

	^ self
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces ohmExpression
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> preferredColor [

	^ Color r: 0.404 g: 0.641 b: 0.125
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> writeRascalSourceOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
