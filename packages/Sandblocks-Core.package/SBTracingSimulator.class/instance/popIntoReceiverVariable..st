instruction decoding
popIntoReceiverVariable: offset

	self trackInstanceVarChange: offset.
	^ currentContext popIntoReceiverVariable: offset