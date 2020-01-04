as yet unclassified
visitMessageNode: aNode

	| arguments node receiver |
	receiver := aNode receiver accept: self.
	arguments := aNode arguments collect: [:arg | arg accept: self].
	
	node := self newNode.
	self connect: receiver output to: (node addInput: (arguments ifEmpty: [aNode selector key] ifNotEmpty: ['self'])).
	
	arguments ifNotEmpty: [
		aNode selector key keywords with: arguments do: [:part :arg |
			self connect: arg output to: (node addInput: part)]].
	
	node addOutput: ''.
	
	^ node