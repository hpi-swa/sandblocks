as yet unclassified
recordTopValueFor: aBlock

	aBlock
		ifNotNil: [:b | b ensureDecorator: SBReportedValueDecorator do: [:d |
			valueDecorators add: d.
			d label: (aBlock isAssignment
				ifTrue: [Compiler new evaluate: aBlock binding contents for: context receiver]
				ifFalse: [context top]) asString.
			d flash]]