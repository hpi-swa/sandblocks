as yet unclassified
addSyncEvent: aColor from: anObject with: aValue

	self addMorphBack: (Morph new
		borderStyle: (SimpleBorder new color: Color black; width: 1);
		extent: 10 asPoint withScalingFactor;
		color: (colorMapping at: anObject ifAbsentPut: [Color random]);
		balloonText: aValue asString;
		on: #click send: #addHalo to: anObject;
		yourself)