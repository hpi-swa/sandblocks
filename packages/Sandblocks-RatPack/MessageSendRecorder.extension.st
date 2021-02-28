Extension { #name : #MessageSendRecorder }

{ #category : #'*Sandblocks-RatPack' }
MessageSendRecorder >> setRecordAllObjects [
	"Hold on to all object pointers for receivers, arguments, and return values."
	
	self setBefore: {[:record :rcvr :args :ctx |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result :ctx |
			record extension
				returnObject: result]}.
]
