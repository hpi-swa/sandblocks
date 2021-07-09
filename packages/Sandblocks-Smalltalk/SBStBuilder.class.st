"
A collection of helpers to quickly create blocks. Use via the extension on BlockClosure:

```
[:b | b to: (b name: 'abc') send: #asUppercase] sbStBuild
```
"
Class {
	#name : #SBStBuilder,
	#superclass : #Object,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBuilder >> array: aCollection [

	^ SBStArray new addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBStBuilder >> assign: aString to: aBlock [

	^ SBStMessageSend new
		receiver: (SBStName contents: aString)
		selector: ':='
		arguments: {aBlock}
]

{ #category : #'as yet unclassified' }
SBStBuilder >> blockWith: anArgsCollection do: aStatementCollection [

	^ (SBStBlockBody emptyWithDeclarations: anArgsCollection)
		statements: aStatementCollection;
		yourself
]

{ #category : #'as yet unclassified' }
SBStBuilder >> cascadedSend: aSymbol [

	^ self to: nil send: aSymbol
]

{ #category : #'as yet unclassified' }
SBStBuilder >> cascadedSend: aMessage with: aBlockOrCollection [

	^ self to: nil send: aMessage with: aBlockOrCollection
]

{ #category : #'as yet unclassified' }
SBStBuilder >> class: aString super: aClass instVars: aCollectionOfStrings [

	^ self class: aString super: aClass instVars: aCollectionOfStrings current: nil
]

{ #category : #'as yet unclassified' }
SBStBuilder >> class: aString super: aSuperClass instVars: aCollectionOfStrings current: aClass [

	| c |
	c := SBStClass new.
	aClass ifNotNil: [c class: aClass].
	c
		superClassName: aSuperClass name;
		className: aString;
		instanceVariables: aCollectionOfStrings.
	^ c
]

{ #category : #'as yet unclassified' }
SBStBuilder >> getter: aString in: aClass [

	^ self method: aString in: aClass do: (self return: (self name: aString))
]

{ #category : #'as yet unclassified' }
SBStBuilder >> initialize: aCollection in: aClass [

	| block |
	block := aClass initializeBlock.
	block body appendStatements: aCollection.
	^ block
]

{ #category : #'as yet unclassified' }
SBStBuilder >> method: aSymbol in: aClass do: aCollection [

	^ self method: aSymbol in: aClass with: #() do: aCollection
]

{ #category : #'as yet unclassified' }
SBStBuilder >> method: aSymbol in: aClass with: aBlockOrCollection do: aStatementOrCollection [

	^ SBStMethod new
		selector: aSymbol
			arguments: (aBlockOrCollection isCollection
				ifTrue: [aBlockOrCollection]
				ifFalse: [{aBlockOrCollection}])
			class: aClass;
		statements: (aStatementOrCollection isCollection
			ifTrue: [aStatementOrCollection]
			ifFalse: [{aStatementOrCollection}]);
		yourself
]

{ #category : #'as yet unclassified' }
SBStBuilder >> name: aString [

	^ SBStName contents: aString
]

{ #category : #'as yet unclassified' }
SBStBuilder >> number: aNumber [

	^ SBStNumber new contents: aNumber asString
]

{ #category : #'as yet unclassified' }
SBStBuilder >> pragma: aSymbol [

	^ self pragma: aSymbol with: {}
]

{ #category : #'as yet unclassified' }
SBStBuilder >> pragma: aSymbol with: aBlockOrCollection [

	^ SBStPragma new selector: aSymbol arguments: (aBlockOrCollection isCollection
		ifTrue: [aBlockOrCollection]
		ifFalse: [{aBlockOrCollection}])
]

{ #category : #'as yet unclassified' }
SBStBuilder >> pragma: aSymbol with: aBlockOrCollection in: aMethod [

	| p |
	p := self pragma: aSymbol with: aBlockOrCollection.
	aMethod body prependStatement: p.
	^ aMethod
]

{ #category : #'as yet unclassified' }
SBStBuilder >> return: aBlock [

	^ SBStReturn new expression: aBlock
]

{ #category : #'as yet unclassified' }
SBStBuilder >> setter: aString in: aClass [

	^ self
		method: aString, ':'
		in: aClass
		with: (self name: 'anObject')
		do: (self assign: aString to: (self name: 'anObject'))
]

{ #category : #'as yet unclassified' }
SBStBuilder >> string: aString [

	^ SBStString new contents: aString
]

{ #category : #'as yet unclassified' }
SBStBuilder >> symbol: aString [

	^ SBStSymbol new contents: aString
]

{ #category : #'as yet unclassified' }
SBStBuilder >> to: aBlock cascade: aCollection [

	^ SBStCascade new receiver: aBlock messages: aCollection
]

{ #category : #'as yet unclassified' }
SBStBuilder >> to: aBlock send: aSymbol [

	^ SBStMessageSend new receiver: aBlock selector: aSymbol arguments: {}
]

{ #category : #'as yet unclassified' }
SBStBuilder >> to: aBlock send: aSymbol with: aBlockOrCollection [

	^ SBStMessageSend new receiver: aBlock selector: aSymbol arguments: (aBlockOrCollection isCollection
		ifTrue: [aBlockOrCollection]
		ifFalse: [{aBlockOrCollection}])
]
