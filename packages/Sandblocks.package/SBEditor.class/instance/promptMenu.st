actions
promptMenu

	| options |
	options := {
		{'Change Color Policy'. [
			self colorPolicy: ((UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self])
				new;
				changed.
			self allMorphsDo: [:morph | morph removeProperty: #sandblockBlockColor]]}.
		{'Change Compile Method'. [self promptChangeCompile]}
	}.
	
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value