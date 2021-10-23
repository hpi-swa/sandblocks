Class {
	#name : #SBTSLanguageTests,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBTSLanguageTests >> testPythonBinaryOperator [

	| block e |
	block := SBMetaBlockFactory python parse: '123'.
	e := self editorFor: block.
	[
		block childSandblocks first
			select;
			keyStroke: (self keyboardEvent: $+)]
		on: ProvideAnswerNotification
		do: [:n | self assert: false].
	
	self assert: (block matchesQuery: '(module (expression_statement (binary_operator)))')
]
