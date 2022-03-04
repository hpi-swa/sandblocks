Class {
	#name : #SBStNameBehavior,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNameBehavior class >> checkCastFor: aBlock parent: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> actions [

	^ Array streamContents: [:stream |
		self class withAllSuperclassesDo: [:class |
			Pragma
				withPragmasIn: class
				do: [:pragma |
					(#(#action #multiSelectAction #inputAction) includes: pragma keyword) ifTrue: [stream nextPut: pragma]].
			SBStNameBehavior = class ifTrue: [^ stream contents]]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> attached: aName [

	name := aName.
	aName currentTextMorph clearEmphasis
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> block [

	^ name
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> block: aBlock [
	" ignore, we already know which block we belong to "
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> castToUnknownWhenEmpty [

	^ self block isExpression
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> contents [

	^ self block contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> contentsChanged [
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> createClass [

	<action>
	<actionValidIf: #noValidBinding>

	self block sandblockEditor do: (SBStCreateClassCommand new
		name: self contents;
		source: self block;
		editor: self block sandblockEditor;
		artefact: self block containingArtefact)
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareBlockVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingBlock declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareClassVariable [
	<action>
	<actionValidIf: #noValidBinding>

	self block sandblockEditor do: (SBStDeclareClassVarCommand new
		class: self block containingArtefact methodClass theNonMetaClass;
		name: self contents;
		source: self block)
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareInstanceVariable [
	<action>
	<actionValidIf: #noValidBinding>

	self block sandblockEditor do: (SBStDeclareInstVarCommand new
		class: self block containingArtefact methodClass;
		name: self contents;
		source: self block)
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareMethodVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingArtefact body declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> detached: aBlock [

	name := nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> doubleClick: anEvent [
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> fixActions [

	^ #()
]

{ #category : #nil }
SBStNameBehavior >> fixActionsForBinding [

	^ self block contents first isUppercase
		ifTrue: [self fixActionsForUppercaseBinding]
		ifFalse: [self fixActionsForLowercaseBinding]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> fixActionsForLowercaseBinding [

	^ Array streamContents: [:stream |
		self block containingBlock ifNotNil: [:b |
			b isMethodBody ifFalse: [
				stream nextPut: (SBCodeAction
					labeled: 'Declare block-local'
					for: self block
					do: [:node | node containingBlock declareTemporaryVariable: node contents])]].
		stream nextPut: (SBCodeAction
			labeled: 'Declare method temporary'
			for: self block
			do: [:node | node containingArtefact body declareTemporaryVariable: node contents]).
		stream nextPut: (SBCodeAction
			labeled: 'Declare instance variable'
			for: self block
			do: [:node | self declareInstanceVariable]).
		self block containingArtefact isMethod ifTrue: [
			stream nextPut: (SBCodeAction labeled: 'Add method argument' for: self block do: [:node |
				node containingArtefact signature
					addArgument: (self argNameToType: node contents)
					block: node veryDeepCopy])]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> fixActionsForUppercaseBinding [

	^ Array streamContents: [:stream |
		stream nextPut: (SBCodeAction
			labeled: 'Declare class variable'
			for: self block
			do: [:node | self declareClassVariable]).
		stream nextPut: (SBCodeAction labeled: 'Create class' for: self block do: [:node | self createClass])]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> globalSuggestions [

	^ (self block completionSuggestionsForBinding: self contents), (self block completionSuggestionsForProjection: self contents)
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> guessedClass [

	^ self block binding ifNotNil: [:b | b value class]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBlockBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBooleanBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isDeclaration [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isKeyword [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isLiteralBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isMethodArgument [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isMethodLocal [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isTemporaryVariable [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> localSuggestions [

	^ Array streamContents: [:stream | self block scopesDo: [:scope | scope declarationsDo: [:decl | (decl contents sandblockMatch: self contents) ifTrue: [stream nextPut: decl asSuggestionItem]]]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> noValidBinding [

	^ self validBinding not
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> prefix [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> printBlockOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> resolveBinding [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> suggestions [

	| suggestions |
	suggestions := self contents ifEmpty: [#()] ifNotEmpty: [
		Array streamContents: [:stream |
			stream
				nextPutAll: self localSuggestions;
				nextPutAll: self globalSuggestions.
			
			]].
	^ suggestions sort: #selectorSize ascending
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> symbolsFor: aColorPolicy [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> valid [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> validBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> wasDeselected [

	
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> wasSelected [

	
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> writeSourceOn: aStream [

	aStream nextPutAll: self block contents
]
