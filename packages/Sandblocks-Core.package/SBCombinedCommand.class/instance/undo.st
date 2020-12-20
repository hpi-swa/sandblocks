as yet unclassified
undo

	self commands allButFirst reverseDo: #undo.
	^ self commands first undo