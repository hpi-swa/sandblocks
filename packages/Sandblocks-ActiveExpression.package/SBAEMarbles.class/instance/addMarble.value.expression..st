as yet unclassified
addMarble: aMorph value: anObject expression: anExpression

	self updateTickDividers.
	self addMorphBack: (SBMarble new
		subject: aMorph;
		value: anObject;
		on: #click send: #selectExpression:event:marble: to: self withValue: anExpression;
		yourself)