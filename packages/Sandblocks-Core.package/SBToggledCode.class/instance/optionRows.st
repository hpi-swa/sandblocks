accessing
optionRows

	^ comment owner ifNotNil: [self submorphs allButFirst] ifNil: [self submorphs]