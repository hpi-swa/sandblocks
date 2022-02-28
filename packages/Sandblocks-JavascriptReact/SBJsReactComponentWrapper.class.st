"
A SBJsReactComponentWrapper wraps a class declaration AST node of Javascript. It is can be used to access the relevant parts of the given class for the replacements used in the Sandblocks-JavascriptReact.

To access these relevant parts like the wrapped component's name, it uses tree sitter queries. 
The wrapper has methods to access specific parts of the component alone like the component name. (Currently no other specific methods are needed.)
Additionally, it also provides a method that extracts all relevant parts into one dictionary using the same query the SBJsComponentUsageReplacement used in its match method. This is useful when needing to access mutliple of the relevant properties of the component by only executing a single tree sitter query. It is mainly used for the html file generation of the SBJsComponentUsageReplacement.

Instance Variables
	reactComponent:		<SBInlineBlockSymbol>

reactComponent
	- An AST node of type 'class_declaration' whose class must contain a render method, an examples array and inherit from React.Component.
"
Class {
	#name : #SBJsReactComponentWrapper,
	#superclass : #Object,
	#instVars : [
		'reactComponent'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #constructor }
SBJsReactComponentWrapper class >> componentNode: aSBInlineBlockSymbolForClassDeclaration [

	aSBInlineBlockSymbolForClassDeclaration type ~= 'class_declaration' ifTrue: [
		self signal: 'Expecting a class declaration that can be wrapped.'.
		^ nil].
	^ self new reactComponent: aSBInlineBlockSymbolForClassDeclaration
]

{ #category : #accessing }
SBJsReactComponentWrapper >> allCaptures [

	self reactComponent allBlocksDo: [:block |
		SBTSQuery new
			execute: SBJsComponentReplacement replacementQuery
			against: block
			capturesDo: [:captures :success | success ifTrue: [^ captures]]].
	^ nil
]

{ #category : #accessing }
SBJsReactComponentWrapper >> componentName [

	^ (self query: self componentNameQuery) contents
]

{ #category : #querying }
SBJsReactComponentWrapper >> componentNameQuery [

	^ '(class_declaration
	name: (identifier) @identifier
)'
]

{ #category : #copy }
SBJsReactComponentWrapper >> copy [

	^ self class componentNode: self reactComponent buildCopy
]

{ #category : #accessing }
SBJsReactComponentWrapper >> existingExamples [

	^ self reactComponent access body children
		detect: [:member | member element class = SBJsComponentReplacement]
		ifNone: [nil]
]

{ #category : #accessing }
SBJsReactComponentWrapper >> positionOfMember: aSBInlineBlock [

	^ self reactComponent access body children indexOf: aSBInlineBlock
]

{ #category : #querying }
SBJsReactComponentWrapper >> query: aQueryString [

	self reactComponent
		queryRecursiveFirstMatch: aQueryString
		capturesDo: [:captures | ^ captures at: 'identifier'].
	^ nil
]

{ #category : #accessing }
SBJsReactComponentWrapper >> reactComponent [

	^ reactComponent
]

{ #category : #accessing }
SBJsReactComponentWrapper >> reactComponent: aSBInlineBlockSymbolForClassDeclaration [

	reactComponent := aSBInlineBlockSymbolForClassDeclaration
]

{ #category : #accessing }
SBJsReactComponentWrapper >> sourceString [

	^ self reactComponent sourceString
]
