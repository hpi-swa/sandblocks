testing
isMethodBody

	^ self owner notNil and: [self parentSandblock isMethod]