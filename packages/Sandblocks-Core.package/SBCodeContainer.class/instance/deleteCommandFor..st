as yet unclassified
deleteCommandFor: aBlock

	^ SBCombinedCommand newWith: {
		SBDeleteCommand newNonEdit target: self.
		"(SBDeleteMethodCommand newFor: SBNullSavable new) method: self method"
	}