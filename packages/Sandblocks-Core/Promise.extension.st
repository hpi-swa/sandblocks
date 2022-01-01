Extension { #name : #Promise }

{ #category : #'*Sandblocks-Core' }
Promise class >> all: aCollection [

	| grouped pending result |
	" resolve when all Promises in aCollection are resolved. If any reject, the returned promise immediately rejects as well, with the error of the first rejected promise "
	pending := aCollection size.
	grouped := Promise new.
	result := aCollection copy.
	aCollection doWithIndex: [:promise :index |
		promise
			whenResolved: [:value |
				pending := pending - 1.
				result at: index put: value.
				pending = 0 ifTrue: [grouped resolveWith: result]];
			whenRejected: [:error | grouped rejectWith: error]].
	^ grouped
]
