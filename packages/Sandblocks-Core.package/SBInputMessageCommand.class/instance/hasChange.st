as yet unclassified
hasChange

	^ previousSelector ~= newSelector or: [(previousArguments hasEqualElements: newArguments) not]