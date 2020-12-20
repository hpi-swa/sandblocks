as yet unclassified
newFor: aBlock

	^ self new
		setUp: aBlock arguments first
		cases: aBlock arguments second submorphs
		extent: aBlock arguments third contents