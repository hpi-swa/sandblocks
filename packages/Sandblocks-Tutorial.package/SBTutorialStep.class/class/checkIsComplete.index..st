as yet unclassified
checkIsComplete: aMethodSymbol index: aNumber

	^ self progress at: aMethodSymbol ifPresent: [:list | list includes: aNumber] ifAbsent: [false]