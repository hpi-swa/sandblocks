as yet unclassified
popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex

	store report: currentContext method pc: currentContext previousPc.
	^ super popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex