as yet unclassified
popIntoReceiverVariable: offset

	(tempObjects includes: currentContext receiver) ifFalse: [
		(SBToggledCode
			comment: 'explicit whitelist needed here, class side object getting some cleanup :('
			active: 1
			do: {
				[currentContext sender methodClass = Encoder and: [currentContext sender selector = #initScopeAndLiteralTables]]
			}) ifFalse: [^ nil]].
	^ currentContext popIntoReceiverVariable: offset