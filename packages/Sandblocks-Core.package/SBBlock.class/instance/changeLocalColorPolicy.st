as yet unclassified
changeLocalColorPolicy
	<action>

	^ (UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNotNil: [:policy |
		self localColorPolicy: policy]