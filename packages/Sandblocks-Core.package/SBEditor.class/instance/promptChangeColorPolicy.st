as yet unclassified
promptChangeColorPolicy

	| policy |
	policy := (UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self].
	self class defaultColorPolicy: policy.
	self colorPolicy: policy new