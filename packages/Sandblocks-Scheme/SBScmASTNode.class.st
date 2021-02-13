Class {
	#name : #SBScmASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'action helpers' }
SBScmASTNode >> actionProviders [

	^ super actionProviders, {self grammarHandler}
]

{ #category : #printing }
SBScmASTNode >> crIndent: aNumber on: aStream [

	aStream cr.
	aNumber timesRepeat: [
		aStream space; space]
]

{ #category : #evaluation }
SBScmASTNode >> evaluate [

	^ QoppaInterpreter new readAndEvaluate: self sourceString
]

{ #category : #accessing }
SBScmASTNode >> grammarHandler [

	^ SBScmGrammarHandler new
]

{ #category : #converting }
SBScmASTNode >> inSmalltalk: converter [
	<convert>
	
	^ converter do: [SBLanguageBox new source: self sourceString lang: 'scheme']
]

{ #category : #'initialize-release' }
SBScmASTNode >> initialize [

	super initialize.
		
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBScmASTNode >> isExpression [

	^ true
]

{ #category : #testing }
SBScmASTNode >> isIdentifier [

	^ false
]

{ #category : #testing }
SBScmASTNode >> isSExpr [

	^ false
]

{ #category : #testing }
SBScmASTNode >> isScheme [

	^ true
]

{ #category : #accessing }
SBScmASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBScmGrammarHandler new
]

{ #category : #'object interface' }
SBScmASTNode >> object [

	^ self
]

{ #category : #'object interface' }
SBScmASTNode >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces scmExpression
]

{ #category : #printing }
SBScmASTNode >> prettySourceString [

	^ String streamContents: [:s |
		self writeSourceOn: s indent: 0]
]

{ #category : #printing }
SBScmASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #printing }
SBScmASTNode >> writeSourceOn: aStream indent: aNumber [

	^ self subclassResponsibility
]
