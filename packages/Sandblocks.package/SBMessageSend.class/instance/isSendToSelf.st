accessing
isSendToSelf

	^ self receiver isName and: [self receiver isReserved] and: [self receiver contents = 'self']