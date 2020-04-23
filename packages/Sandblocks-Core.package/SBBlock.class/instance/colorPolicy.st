as yet unclassified
colorPolicy

	^ self sandblockEditor ifNotNil: #colorPolicy ifNil: [SBDefaultColorPolicy new]