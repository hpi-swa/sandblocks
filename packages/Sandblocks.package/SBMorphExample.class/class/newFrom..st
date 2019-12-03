as yet unclassified
newFrom: aBlock

	^ self new
		setUp: aBlock arguments first
		cases: (aBlock arguments second submorphs)
		extent: aBlock arguments third contents