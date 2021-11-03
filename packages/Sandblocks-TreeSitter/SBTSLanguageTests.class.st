Class {
	#name : #SBTSLanguageTests,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBTSLanguageTests >> testPythonBinaryOperator [

	| block e |
	block := SBPython parse: '123'.
	e := self editorFor: block.
	[
		block childSandblocks first
			select;
			keyStroke: (self keyboardEvent: $+)]
		on: ProvideAnswerNotification
		do: [:n | self assert: false].
	
	self assert: (block matchesQuery: '(module (expression_statement (binary_operator)))')
]

{ #category : #'as yet unclassified' }
SBTSLanguageTests >> testPythonNumber [

	| block e |
	block := SBPython parse: 'a'.
	e := self editorFor: block.
	block childSandblocks first
		select;
		insertStatementBelow.
	[block childSandblocks second keyStroke: (self keyboardEvent: $1)]
		on: ProvideAnswerNotification
		do: [:n | self assert: false].
	
	self assert: (block matchesQuery: '(module (expression_statement (integer)))')
]
