as yet unclassified
wantsMultiRow: aMorph

	^ aMorph temporaries notEmpty or: [aMorph statementCount > 1 or: [aMorph statementCount > 0 and: [aMorph statements first minExtent x > (200 * aMorph scalingFactor)]]]