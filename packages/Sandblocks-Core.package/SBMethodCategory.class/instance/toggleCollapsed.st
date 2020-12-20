as yet unclassified
toggleCollapsed
	<action>
	
	self submorphCount > 1
		ifTrue: [(self submorphs copyFrom: 2 to: self submorphCount) do: #delete]
		ifFalse: [self addMethods]