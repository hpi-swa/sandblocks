as yet unclassified
addSyncEventFrom: anObject with: aValue

	self updateTickDividers.
	self addMorphBack: (SBMarble new
		subject: anObject;
		isSync: true;
		value: aValue;
		on: #click send: #selectSubject:event:subject: to: self withValue: anObject;
		yourself)
	
	"(Morph new
		borderStyle: (SimpleBorder new color: Color black; width: 1);
		extent: 10 asPoint withScalingFactor;
		color: anObject sandblockColor;
		balloonText: aValue asString;
		on: #click send: #addHalo to: anObject;
		yourself)"