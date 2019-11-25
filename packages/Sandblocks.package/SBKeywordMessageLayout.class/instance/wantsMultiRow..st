as yet unclassified
wantsMultiRow: aMorph

	| sum |
	sum := 0.
	" not an exact measure, but indicative of the space that would be taken "
	aMorph submorphs do: [:m | sum := sum + (m minExtent x)].
	^ sum > (250 * aMorph scalingFactor)