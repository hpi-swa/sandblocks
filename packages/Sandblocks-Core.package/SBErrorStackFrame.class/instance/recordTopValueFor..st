as yet unclassified
recordTopValueFor: aBlock

	aBlock
		ifNotNil: [:b | b ensureDecorator: SBReportedValueDecorator do: [:d |
			valueDecorators add: d.
			d label: context top asString.
			d flash]]