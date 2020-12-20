as yet unclassified
reset: anEditor

	steps removeAllMorphs.
	anEditor closeAll.
	anEditor openMorphInView: self.
	setup value: self.
	self extent: 0 @ 0.
	anEditor when: #selectionChanged send: #checkConditions to: self