as yet unclassified
updatePCFrom: aBlock

	super updatePCFrom: aBlock.
	self endPC: aBlock endPC.
	self startPC: aBlock startPC