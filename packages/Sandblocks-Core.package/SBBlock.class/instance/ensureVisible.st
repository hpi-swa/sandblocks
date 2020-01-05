testing
ensureVisible

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]