as yet unclassified
valid: aBoolean

	Transcript show: aBoolean;  cr.
	self color: (aBoolean ifTrue: [Color green] ifFalse: [Color black])