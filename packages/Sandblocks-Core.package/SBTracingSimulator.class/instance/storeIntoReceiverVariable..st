instruction decoding
storeIntoReceiverVariable: offset 

	self trackInstanceVarChange: offset.
	^ super storeIntoReceiverVariable: offset