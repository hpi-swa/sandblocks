as yet unclassified
savedMethodHasComments

	SBExample self: [
		SBMethod newFor: SBMethod >> #savedMethodHasComments at: 0 @ 0] args: [{}] label: 'no comment'.
	SBExample self: [SBMethod newFor: SBEditor >> #do: at: 0 @ 0] args: [{}] label: 'has comment'.
	^ self methodClass methodDictionary
		at: self selector asSymbol
		ifPresent: [:method | | scanner |
			scanner := Scanner new scan: method getSourceFromFile readStream.
			[
				scanner advance.
				scanner tokenType = #doIt] whileFalse: [scanner currentComment ifNotNil: [^ true]].
			false]
		ifAbsent: [false]