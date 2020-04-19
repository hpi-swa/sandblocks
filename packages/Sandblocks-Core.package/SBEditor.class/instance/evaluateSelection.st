actions
evaluateSelection

	| result explorer source artefact |
	source := self selection.
	artefact := source containingArtefact.
	result := source evaluateWith: artefact for: (errors focusedArtefact = artefact ifTrue: [errors focusedContext] ifFalse: [nil]).
	
	source containingArtefact cacheType: result class for: source.
	
	self openMorphInView: (explorer := result asSandblock
		focusAfterDelete: source;
		yourself).
	
	scroll addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: source to: explorer;
		yourself)