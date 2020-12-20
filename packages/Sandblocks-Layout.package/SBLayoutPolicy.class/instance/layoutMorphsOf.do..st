as yet unclassified
layoutMorphsOf: aMorph do: aBlock

	| count |
	count := 0.
	aMorph submorphs do: [:morph |
		(morph disableLayout not and: [morph visible]) ifTrue: [
			aBlock value: morph.
			count := count + 1]].
	^ count