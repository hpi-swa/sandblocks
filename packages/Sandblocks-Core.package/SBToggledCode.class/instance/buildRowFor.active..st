as yet unclassified
buildRowFor: aBlock active: aBoolean

	| row |
	row := SBRow new.
	row
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBBoolean new
			parsedContents: aBoolean;
			when: #toggled evaluate: [self deselectAllBut: (self submorphIndexOf: row) - 1; updateSelected]);
		addMorphBack: (aBlock setProperty: #previousBlockColor toValue: (aBlock valueOfProperty: #sandblockBlockColor ifAbsent: [Color random])).
	^ row