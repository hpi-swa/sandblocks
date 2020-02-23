as yet unclassified
postDuplicate

	currentSelector isBinary ifTrue: [^ self shouldBeImplemented].
	
	self currentSelector: 'copy', currentSelector capitalized.
	self selector: self currentSelector arguments: self arguments.
	
	super postDuplicate