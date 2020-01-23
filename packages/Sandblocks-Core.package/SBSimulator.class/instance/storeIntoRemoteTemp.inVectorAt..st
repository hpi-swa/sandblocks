as yet unclassified
storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
	"Store Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex