actions
ensureVisible
	<action>

	| method |
	method := self containingArtefact.
	(method ~= self and: [method notNil and: [self visibleInWorld not]]) ifTrue: [method ensureExpanded].
	
	Project current addDeferredUIMessage: [
		self isInWorld ifTrue: [self sandblockEditor ifNotNil: [:e | e scrollToShow: self]]]