as yet unclassified
wantsReceiverAndMessageRow: aMorph

	^ aMorph signature submorphCount = 2 and: [aMorph receiver notNil and: [aMorph receiver minExtent x < aMorph signature lastSubmorph minExtent x]]