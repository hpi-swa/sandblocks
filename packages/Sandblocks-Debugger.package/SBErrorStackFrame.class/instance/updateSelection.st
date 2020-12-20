as yet unclassified
updateSelection

	pcIndicator ifNotNil: #detach.
	self currentBlock ifNotNil: [:block | 
		block
			select;
			attachDecorator: (pcIndicator := SBErrorDecorator new)]