actions
promptMenu

	| options |
	options := {
		{'Change Color Policy'. [
			self colorPolicy: ((UIManager default chooseFrom: SBColorPolicy withAllSubclasses values: SBColorPolicy withAllSubclasses) ifNil: [^ self])
				new;
				changed.
			self allMorphsDo: [:morph | morph removeProperty: #sandblockBlockColor]]}.
		{'Change Compile Method'. [self promptChangeCompile]}.
		{'New Class'. [self openMorphInView: (SBClass new category: (self anyNearbyClass ifNotNil: #category ifNil: ['UserObjects']))]}
	}.
	
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value