as yet unclassified
isAlgebraLayoutRoot: aMorph

	^ aMorph owner isNil or: [aMorph owner layoutPolicy class ~= SBAlgebraLayout]