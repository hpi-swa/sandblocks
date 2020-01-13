as yet unclassified
reportValue: anObject

	| subject |
	self flag: #fixme.
	subject := thisContext sender sender sender sender receiver.
	anObject onChangeDo: [:newValue | 
		self updateTickDividers.
		self addMorphBack: (CircleMorph new
			 extent: self marbleSize withScalingFactor;
			 color: subject sandblockColor;
			 balloonText: newValue asString;
			 on: #click send: #addHalo to: subject;
			 yourself)]