as yet unclassified
createSubclass
	<action>

	self sandblockEditor openMorphInView: (SBClass new
		hasUnsavedChanges: true;
		category: self category;
		superClassName: className contents;
		yourself)