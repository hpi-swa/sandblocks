testing
ensureVisible

	| method |
	method := self containingMethod.
	(method ~= self and: [method notNil]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]