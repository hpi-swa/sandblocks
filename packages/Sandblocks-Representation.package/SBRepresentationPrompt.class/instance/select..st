as yet unclassified
select: aNumber

	| candidates |
	candidates := self candidates.
	options submorphsDo: [:m | m detachDecorators: SBMultiSelectionDecorator].
	selectedIndex := aNumber clampLow: 1 high: candidates size.
	candidates ifNotEmpty: [ | selected |
		selected := candidates at: selectedIndex.
		selected attachDecorator: SBMultiSelectionDecorator new.
		scroll scrollToShow: (selected bounds expandBy: 0 @ 50).
		self sandblockEditor ifNotNil: [
			self useRepresentation: (selected valueOfProperty: #representation)]]