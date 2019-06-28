*Sandblocks
reverseAllMorphsDo: aBlock

	submorphs reverseDo: [:m | m reverseAllMorphsDo: aBlock].
	aBlock value: self