as yet unclassified
visitMessageNode: aNode

	| arguments node receiver |
	receiver := aNode originalReceiver accept: self.
	arguments := aNode originalArguments collect: [:arg | arg accept: self].
	
	node := self newNode: SBMessageNode.
	node selector: aNode originalSelector.
	self connect: receiver outputSockets first to: node inputSockets first.
	
	arguments ifNotEmpty: [
		node inputSockets allButFirst with: arguments do: [:input :arg |
			self connect: arg outputSockets first to: input]].
	
	^ node