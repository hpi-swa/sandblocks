as yet unclassified
startProfiling
	<action>

	| tally |
	
	currentlyProfiling := true.
	self removeAllMorphs.
	
	tally := MessageTally new.
	tally spyEvery: 1 on: [
		[currentlyProfiling] whileTrue: [self world doOneCycle]].
	
	self openFrame: tally