as yet unclassified
updateSelection

	pcIndicator ifNotNil: #detach.
	((self sandblockEditor openCompiledMethod: self context method) blockForPC: (self isActiveFrame ifTrue: [self context pc] ifFalse: [self context previousPc])) ifNotNil: [:block | 
		block
			select;
			attachDecorator: (pcIndicator := SBErrorDecorator new)]