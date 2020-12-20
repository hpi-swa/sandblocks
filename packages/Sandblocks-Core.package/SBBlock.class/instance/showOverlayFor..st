as yet unclassified
showOverlayFor: anEvent

	| overlay |
	overlay := SBOverlay new
		openInWorld;
		sandblockEditor: self sandblockEditor;
		center: (self localPointToGlobal: anEvent position).
	
	anEvent hand newMouseFocus: overlay