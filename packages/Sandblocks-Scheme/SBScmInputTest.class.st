Class {
	#name : #SBScmInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Scheme-Tests'
}

{ #category : #'as yet unclassified' }
SBScmInputTest >> testWrapString [

	| editor module string |
	module := SBScmModule fromString: '("abc")'.
	editor := (self editorFor: module) useTextInput.
	string := module statements first childSandblocks first.
	
	editor startInput: string at: 1 replacingContents: false.
	
	self send: (self keyboardEvent: Character arrowUp shift: true command: false) to: editor.
	self send: (self keyboardEvent: $() to: editor.
	
	self assert: 'abc' equals: string contents.
	self assert: string parentSandblock isSExpr.
	self assert: string parentSandblock parentSandblock isSExpr
]
