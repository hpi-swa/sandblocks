*Sandblocks-Core
withInsert: anObject at: anIndex

	^ self copyReplaceFrom: anIndex to: anIndex - 1 with: {anObject}