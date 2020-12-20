as yet unclassified
currentContextIsWhiteListed

	^ SBToggledCode
		comment: 'explicit whitelist needed here, class side object getting some cleanup :('
		active: 1
		do: {
			[currentContext sender methodClass = Encoder and: [currentContext sender selector = #initScopeAndLiteralTables]]
		}