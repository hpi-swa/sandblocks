as yet unclassified
watchTypes

	^ {
		SBDisplayBarChart.
		Smalltalk at: #SBDisplayActiveExpressionMarbles ifAbsent: [nil].
		Smalltalk at: #SBDisplayActiveExpression ifAbsent: [nil].
		SBDisplayColor.
		SBDisplayMorph.
		SBDisplayCanvas.
		SBDisplayForm.
		SBDisplayPrint.
		SBDisplayText.
		SBDisplayMultiple.
	} select: #notNil