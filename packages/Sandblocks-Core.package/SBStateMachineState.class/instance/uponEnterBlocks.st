as yet unclassified
uponEnterBlocks

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Enter:']) collect: [:row | row submorphs second]