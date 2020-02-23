as yet unclassified
uponLeaveBlocks

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Leave:']) collect: [:row | row submorphs second]