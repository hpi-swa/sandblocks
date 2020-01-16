as yet unclassified
wantsSingleRow: aReceiverMorph signature: aSignatureMorph

	^ aReceiverMorph minExtent x + (aSignatureMorph submorphs collect: [:m | m minExtent x]) sum < SBKeywordMessageLayout widthThreshold