as yet unclassified
buildRowFor: aBlock active: aBoolean

	| row |
	row := SBRow new.
	row
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBCheckbox new
			nonEdit: false;
			value: aBoolean;
			when: #toggled
				evaluate: [
					self
						deselectAllBut: (self optionRows indexOf: row);
						updateSelected];
			yourself);
		addMorphBack: (aBlock
			setProperty: #previousBlockColor
			toValue: (aBlock valueOfProperty: #sandblockBlockColor ifAbsent: [Color random])).
	^ row