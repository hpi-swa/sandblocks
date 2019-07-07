as yet unclassified
browse

	Smalltalk at: self selector asSymbol ifPresent: [:c | ^ self systemNavigation browseClass: c].
	self browseImplementors