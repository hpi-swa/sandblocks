as yet unclassified
testMultilineStringWithIndent

	| string |
	string := 'test

	true ifTrue: [self equals: ''a
b
c
d'']'.
	
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)