accessing
isSendToSelf

	^ self receiver notNil and: [self receiver isName and: [self receiver isReserved] and: [self receiver contents = 'self']]