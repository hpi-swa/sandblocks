as yet unclassified
wasSelected

	| method |
	method := self sandblockEditor open: self context method homeMethod.
	self detachDecorators: SBErrorDecorator; attachDecorator: SBErrorDecorator new.
	self updateSelection.
	super wasSelected