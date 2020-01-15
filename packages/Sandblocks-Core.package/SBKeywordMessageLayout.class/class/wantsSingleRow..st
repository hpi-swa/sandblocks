as yet unclassified
wantsSingleRow: aMorph

	^ aMorph submorphCount <= 2 or: [(self wantsMultiRow: aMorph) not]