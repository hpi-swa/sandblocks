as yet unclassified
wantsMultiRow: aMorph

	^ aMorph statementCount > 1 or: [aMorph submorphs third minExtent x > (200 * aMorph scalingFactor)]