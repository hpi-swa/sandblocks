accessing
valid

	" check that this name does not already exist in a parent scope "
	^ super valid and: [(self containingBlock parentSandblock bindingFor: self contents ifPresent: [:binding | true]) isNil]