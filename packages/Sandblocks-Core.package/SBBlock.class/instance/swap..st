as yet unclassified
swap: aNumber

	| next children |
	children := self parentSandblock childSandblocks select: #canSwap.
	children ifEmpty: [^ self].
	
	next := children atWrap: (children indexOf: self) + aNumber.
	next ifNotNil: [
		self sandblockEditor
			do: ((SBSwapCommand newFor: self containingArtefact)
				a: self;
				b: next)]