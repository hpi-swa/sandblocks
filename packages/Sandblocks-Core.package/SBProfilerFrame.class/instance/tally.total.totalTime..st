as yet unclassified
tally: aTally total: total totalTime: totalTime

	| percentage label |
	tally := aTally.
	percentage := (tally tally asFloat / total) * 100.0.
	label := String streamContents: [:s |
		s
			nextPutAll: (percentage printShowingDecimalPlaces: 1);
			nextPutAll: '% {';
			print: ((percentage * totalTime) / 100) rounded;
			nextPutAll: 'ms} '.
		tally receivers
			ifNil: [s nextPutAll: 'primitives']
			ifNotNil: [ | selector class className |
				selector := tally method selector.
				class := tally method methodClass.
				className := class name.
				tally blockNesting > 0 ifTrue: [
					s
						next: tally blockNesting put: $[;
						next: tally blockNesting put: $];
						space].
				s
					nextPutAll: class name;
					nextPutAll: (class = tally class ifTrue: ['>>'] ifFalse: [('(', class name), ')>>']);
					nextPutAll: selector;
					cr]].
	
	"self addMorphBack: (SBStringMorph new contents: label)."
	self balloonText: label.
	self addMorphBack: (Morph new extent: 1 @ 1).
	
	(tally tally / total) > 0.6 ifTrue: [
		tally receivers do: [:childTally |
			self addMorphBack: (SBProfilerFrame new tally: childTally total: total totalTime: totalTime)]]