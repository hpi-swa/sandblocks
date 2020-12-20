as yet unclassified
jump: offset if: condition 
	store report: currentContext method pc: currentContext previousPc.
	^ super jump: offset if: condition