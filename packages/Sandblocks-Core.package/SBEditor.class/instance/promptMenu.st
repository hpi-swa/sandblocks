actions
promptMenu
	<action>

	| options |
	options := {
		({'Change UI Theme'. [self promptChangeColorPolicy]}).
		({'Reset UI Theme'. [self resetColorPolicy]}).
		({'Change Compile Method'. [self promptChangeCompile]}).
		({'New Class'. [self createEmptyClass]}).
		({'New Representation'. [self createEmptyRepresentation]}).
	}.
	(UIManager default chooseFrom: (options collect: #first) values: (options collect: #second)) ifNotNil: #value