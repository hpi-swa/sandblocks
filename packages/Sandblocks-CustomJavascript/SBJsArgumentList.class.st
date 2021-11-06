Class {
	#name : #SBJsArgumentList,
	#superclass : #SBJsASTNode,
	#instVars : [
		'symbols'
	],
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsArgumentList >> centerAlignSymbols [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> extent: aPoint [

	super extent: (aPoint max: self layoutInset asEdgeInsets x @ self minimumHeight)
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> initialize [

	symbols := #(nil nil).
	super initialize
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> isStatement [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self values collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBJsVariable new
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> objectInterfaceNear: aBlock at: aSymbol [

	^ SBInterfaces jsVariable
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> symbols [

	^ symbols
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> symbols: aCollection [

	symbols := aCollection
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> valid [

	^ self submorphs allSatisfy: [:m | (m isKindOf: SBJsVariable) or: [m isUnknown]]
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> values [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> values: aCollection [

	self addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBJsArgumentList >> wantsExtraSpace [

	^ false
]
