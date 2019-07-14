as yet unclassified
method: aMethodBlock

	self okToChange ifFalse: [^ self].
	
	methodContainer method: aMethodBlock.
	self resetState.
	self changed: #relabel.
	
	self resizeToFit