as yet unclassified
acceptDroppingMorph: aMorph event: anEvent

	self allOwnersDo: #resetHighlightForDrop.
	self resetHighlightForDrop.
	
	aMorph isSelection ifTrue: [
		self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) replacer: aMorph childSandblocks first; target: self)]