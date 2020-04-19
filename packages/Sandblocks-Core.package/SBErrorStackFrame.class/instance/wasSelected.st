as yet unclassified
wasSelected

	| method |
	super wasSelected.
	method := self sandblockEditor openCompiledMethod: self context method.
	self detachDecorators: SBErrorDecorator; attachDecorator: SBErrorDecorator new.
	self updateSelection.
	self triggerEvent: #selected with: self