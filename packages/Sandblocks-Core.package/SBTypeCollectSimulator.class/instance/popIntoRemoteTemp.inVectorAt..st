as yet unclassified
popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
	"Remove Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex