formatting
valid

	^ self containingStatement = self and: [self containingBlock submorphs last = self]