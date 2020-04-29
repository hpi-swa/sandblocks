accessing
valid

	" check that this name does not already exist in a parent scope "
	^ (self block containingBlock parentSandblock bindingFor: self contents class: self block containingArtefact relatedClass ifPresent: [:binding |]) isNil