accessing
addSyncEventFrom: anObject with: aValue

	self updateTickDividers.
	self addMorphBack: (SBMarble new
		subject: anObject;
		isSync: true;
		value: aValue;
		on: #click send: #selectSubject:event:subject: to: self withValue: anObject;
		yourself)