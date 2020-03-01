callbacks
showDependencies

	self currentExpression simulateMonitoredBlock ifNotNil: [:simulation |
		({'Literal Variables:'}, (simulation litVarAccesses ifEmpty: [{'---'}]),
		{'Instance Variables:'}, (simulation instVarAccesses associations
			collect: [:assoc | assoc key -> (assoc value collect: [:index | assoc key class instVarNameForIndex: index + 1])]),
		{'Temporary Variables:'}, (simulation tempVarAccesses ifEmpty: [{'---'}])) explore]