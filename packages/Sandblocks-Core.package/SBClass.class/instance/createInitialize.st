as yet unclassified
createInitialize
	<action>

	self sandblockEditor openMorphInView: (SBMethod new
		selector: 'initialize' arguments: #() class: self shownClass;
		hasUnsavedChanges: true;
		body: (SBBlockBody new statements: {
			(SBMessageSend new receiver: (SBName contents: 'super') selector: 'initialize' arguments: #())
		}))