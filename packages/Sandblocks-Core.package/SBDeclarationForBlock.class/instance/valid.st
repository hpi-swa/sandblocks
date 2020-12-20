accessing
valid

	" check that this name does not already exist in a parent scope "
	^ (self block containingBlock parentSandblock binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:binding | binding]) isNil