as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	aBlock isSelection ifTrue: [
		self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) replacer: aBlock childSandblocks first; target: self)]