as yet unclassified
do

	" since this is an input command, we're executed ahead of time implicitly and will later get one 'do' when we're put in the undo queue, so we only want to run this code here if we're being asked for a redo "
	unknown owner ifNotNil: [
		unknown replaceBy: replacer]