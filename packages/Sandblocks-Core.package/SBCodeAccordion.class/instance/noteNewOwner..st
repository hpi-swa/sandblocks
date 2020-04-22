testing
noteNewOwner: aMorph

	super noteNewOwner: aMorph.
	aMorph sandblockEditor when: #selectionChanged send: #checkExclusiveFocusTo: to: self