as yet unclassified
colorPolicy

	^ self valueOfProperty: #localColorPolicy ifAbsent: [self parentSandblock ifNotNil: #colorPolicy ifNil: [SBDefaultColorPolicy new]]