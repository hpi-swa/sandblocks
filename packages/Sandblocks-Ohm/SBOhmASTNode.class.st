Class {
	#name : #SBOhmASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmASTNode >> actionProviders [

	^ {self grammarHandler. self}
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
SBOhmASTNode >> isOhm [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmASTNode >> isQuantifier [

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
SBOhmASTNode >> maybeUnwrapList [

	^ self
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
SBOhmASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
