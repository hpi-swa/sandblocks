as yet unclassified
do

	previousClass ~= class ifTrue: [
		class compile: (class >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	class organization classify: selector under: category logged: true