as yet unclassified
nextVerticalNear: aNumber calcDistance: aDistBlock validBlock: aValidBlock

	| allCandidates candidates candidatesBestDistance tolerance artefact |
	artefact := self parentSandblock containingArtefact ifNil: [self containingArtefact].
	tolerance := 10.
	
	allCandidates := Array streamContents: [:stream |
		artefact allBlocksDo: [:candidate |
			(candidate hasChildSandblocks not and: [aValidBlock value: candidate]) ifTrue: [stream nextPut: candidate]]].
	
	candidates := OrderedCollection new.
	candidatesBestDistance := 900000000.
	allCandidates do: [:candidate | | distance |
		distance := aDistBlock value: candidate.
		distance < candidatesBestDistance
			ifTrue: [
				(candidatesBestDistance between: distance and: distance + tolerance) ifTrue: [candidates add: candidate] ifFalse: [candidates := OrderedCollection with: candidate].
				candidatesBestDistance := distance]
			ifFalse: [
				(distance between: candidatesBestDistance and: candidatesBestDistance + tolerance) ifTrue: [candidates add: candidate]]].
	
	^ candidates detectMin: [:candidate |
		((candidate center x - artefact left) - aNumber) abs]