as yet unclassified
definitionString

	SBExample self: [SBClass new class: SBClass] args: [{}] label: 'simple'.
	^ '{1} subclass: #{2}
	instanceVariableNames: ''{3}''
	classVariableNames: ''{4}''
	poolDictionaries: ''{5}''
	category: ''{6}''' format: {
		superClassName contents.
		className contents.
		(instanceVariables childSandblocks collect: #contents) joinSeparatedBy: ' '.
		(classVariables childSandblocks collect: #contents) joinSeparatedBy: ' '.
		(poolDictionaries childSandblocks collect: #contents) joinSeparatedBy: ' '.
		category contents}