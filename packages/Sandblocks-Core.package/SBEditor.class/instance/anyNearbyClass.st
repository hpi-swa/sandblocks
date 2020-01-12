actions
anyNearbyClass

	| artefact |
	artefact := (self selection ifNil: [self submorphs first]) containingArtefact.
	artefact isMethod ifTrue: [^ artefact methodClass].
	artefact isClassContainer ifTrue: [^ artefact shownClass].
	^ nil