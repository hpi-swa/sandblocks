as yet unclassified
pushTemporaryVariable: offset

	"Transcript showln: {currentContext tempAt: offset + 1. currentContext endPC}."
	
	^ currentContext pushTemporaryVariable: offset