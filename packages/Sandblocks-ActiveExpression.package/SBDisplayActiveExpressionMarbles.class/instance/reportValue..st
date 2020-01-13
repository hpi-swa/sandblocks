as yet unclassified
reportValue: anObject

	| subject |
	self flag: #fixme.
	subject := thisContext sender sender sender sender receiver.
	anObject onChangeDo: [:newValue | 
		self updateTickDividers.
		self addMorphBack: (SBMarble new subject: subject value: newValue)]