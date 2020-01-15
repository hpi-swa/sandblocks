as yet unclassified
wantsSingleColumn: aMorph

	^ aMorph submorphCount = 2 and: [aMorph submorphs second minExtent y > 100 and: [aMorph submorphs first minExtent x > 100]]