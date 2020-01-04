*Sandblocks-Core
replaceBy: aMorph

	| currentOwner index |
	currentOwner := self owner.
	index := currentOwner submorphIndexOf: self.
	self delete.
	currentOwner addMorph: aMorph asElementNumber: index