as yet unclassified
testMultilineString

	| string |
	string := 'test

	self equals: ''a
b
c
d'''.
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)