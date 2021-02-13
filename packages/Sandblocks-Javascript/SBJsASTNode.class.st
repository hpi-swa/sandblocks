Class {
	#name : #SBJsASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'action helpers' }
SBJsASTNode >> actionProviders [

	^ super actionProviders, {self grammarHandler}
]

{ #category : #drawing }
SBJsASTNode >> centerAlignSymbols [

	^ false
]

{ #category : #accessing }
SBJsASTNode >> grammarHandler [

	^ SBJsGrammarHandler new
]

{ #category : #'initialize-release' }
SBJsASTNode >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBJsASTNode >> isBinaryOperator [

	^ false
]

{ #category : #testing }
SBJsASTNode >> isClosure [

	^ false
]

{ #category : #testing }
SBJsASTNode >> isExpression [

	^ true
]

{ #category : #testing }
SBJsASTNode >> isJavascript [

	^ true
]

{ #category : #accessing }
SBJsASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBJsGrammarHandler new
]

{ #category : #'object interface' }
SBJsASTNode >> object [

	^ self
]

{ #category : #'object interface' }
SBJsASTNode >> objectInterfaceAt: aNumber adding: aBoolean [

	^ (self fixedNumberOfChildren and: [aBoolean]) ifTrue: [SBInterfaces never] ifFalse: [SBInterfaces jsExpression]
]

{ #category : #printing }
SBJsASTNode >> prettySourceString [

	^ self sourceString
]

{ #category : #printing }
SBJsASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #printing }
SBJsASTNode >> writeSourceOn: aStream [

	self subclassResponsibility
]
