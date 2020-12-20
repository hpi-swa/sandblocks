as yet unclassified
do

	unwrapped := target childSandblocks.
	target parentSandblock addAllMorphs: unwrapped after: target.
	target delete.
	^ unwrapped first