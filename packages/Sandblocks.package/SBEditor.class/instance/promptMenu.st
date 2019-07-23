actions
promptMenu

	| options option |
	options := {
		{'Change Color Policy'. [self colorPolicy: ((UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self]) new; changed]}
	}.
	
	option := UIManager default chooseFrom: (options collect: #first) values: (options collect: #second).
	option ifNotNil: #value