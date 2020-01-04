as yet unclassified
labeled: aString for: aNodeBlock do: aBlock

	^ self new
		label: aString;
		target: aNodeBlock;
		action: aBlock;
		yourself