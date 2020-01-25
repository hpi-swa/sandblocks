as yet unclassified
beginDraw

	previousHigherPerformance ifNil: [
		previousHigherPerformance := Preferences valueOfFlag: #higherPerformance.
		Preferences setFlag: #higherPerformance toValue: true]