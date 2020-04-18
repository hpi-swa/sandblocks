actions
evaluateSelection

	| result explorer source |
	result := self selection evaluateWith: self selection containingArtefact.
	source := self selection.
	
	source containingArtefact cacheType: result class for: source.
	
	self openMorphInView: (explorer := result asSandblock
		focusAfterDelete: source;
		yourself).
	
	scroll addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: source to: explorer;
		yourself)