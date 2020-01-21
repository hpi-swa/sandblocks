as yet unclassified
formatString: aString class: aClass noPattern: aBoolean 
	| result formatter node methodNode |
	SBExample
		self: [SBFormatter]
		args: [{'self halt; yourself'. UndefinedObject. true}]
		label: 'string test'.
	methodNode := Parser new
				parse: aString
				class: aClass
				noPattern: aBoolean
				notifying: nil
				ifFail: nil.
	node := aBoolean
				ifTrue: [methodNode body statements first expr]
				ifFalse: [methodNode].
	formatter := self new initForNode: node.
	node accept: formatter.
	result := formatter contents.
	SBLabel
		text: ['Sanity check to not produce invalid code'].
	
	methodNode accept: (ParseNodeEnumerator ofBlock: [:n | n comment: nil]).
	
	self assert: methodNode asString = (Parser new
				parse: result
				class: aClass
				noPattern: aBoolean
				notifying: nil
				ifFail: nil) asString.
	^ result