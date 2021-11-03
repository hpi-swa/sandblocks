Class {
	#name : #SBJsBlockScope,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsBlockScope >> binding: aString for: block class: aClass ifPresent: aBlock [

	self statements detect: [:stmt | stmt isDeclaration and: [stmt lhs contents = aString]] ifFound: [:stmt | ^ aBlock value: stmt] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> fixedArity [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> isMethodBody [

	^ self owner ifNotNil: #isMethod ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: self layoutCommandsForStatements
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> layoutCommandsForStatements [

	^ self statements collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true]
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> objectInterfaceNear: aBlock at: aSymbol [

	(aSymbol = #replace or: [self dynamicNumberOfChildren]) ifTrue: [^ SBInterfaces jsStatement].
	^ SBInterfaces never
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> preferredColorIn: aColorPolicy [

	^ aColorPolicy important
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statements [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statements: aCollection [

	(self submorphs copyFrom: self statementsIndex to: self submorphCount) do: #delete.
	self addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statementsIndex [

	^ 1
]
