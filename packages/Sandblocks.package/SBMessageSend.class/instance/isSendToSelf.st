accessing
isSendToSelf

	^ self receiver isReserved and: [self receiver contents = 'self']