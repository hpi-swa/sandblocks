as yet unclassified
popIntoReceiverVariable: offset

	self trackInstanceVarChange: offset.
	^ currentContext popIntoReceiverVariable: offset