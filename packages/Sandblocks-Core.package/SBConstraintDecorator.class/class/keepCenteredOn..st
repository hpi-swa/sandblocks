as yet unclassified
keepCenteredOn: aMorph

	^ self new with: #center of: aMorph do: [:center :target | target center: center]