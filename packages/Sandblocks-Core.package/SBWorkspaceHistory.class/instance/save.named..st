as yet unclassified
save: anEditor named: aString

	items add: (SBWorkspaceRecord new
		workspaceString: anEditor storeString;
		name: aString;
		date: DateAndTime now;
		yourself)