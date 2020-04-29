as yet unclassified
buildRowFor: aBlock active: aBoolean

	| row |
	row := SBRow new.
	row
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBCheckbox new
			when: #toggled
				evaluate: [
					self
						deselectAllBut: (self submorphIndexOf: row) - 1;
						updateSelected];
			value: aBoolean;
			yourself);
		addMorphBack: (aBlock
			setProperty: #previousBlockColor
			toValue: (aBlock valueOfProperty: #sandblockBlockColor ifAbsent: [Color random])).
	^ row