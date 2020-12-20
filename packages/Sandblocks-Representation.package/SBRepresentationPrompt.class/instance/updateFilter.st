as yet unclassified
updateFilter

	| filter |
	filter := self submorphs second contents.
	options submorphsDo: [:morph | | visible |
		visible := filter isEmpty or: [
			(morph contents findString: filter startingAt: 1 caseSensitive: false) > 0].
		morph
			visible: visible;
			disableLayout: visible not].
	self select: 1