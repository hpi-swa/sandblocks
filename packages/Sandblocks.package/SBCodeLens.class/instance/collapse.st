as yet unclassified
collapse

	self vResizing: #rigid.
	scroll disableLayout: false; visible: true.
	
	(self findDeepSubmorphThat: [:morph | morph isSandblock and: [morph marked]] ifAbsent: [nil])
		ifNotNil: [:morph | self focus: morph]
		ifNil: [scroll visible: false]