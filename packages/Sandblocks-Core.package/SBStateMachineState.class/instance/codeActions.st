as yet unclassified
codeActions

	| states index |
	^ {
		(SBCodeAction
			labeled: 'Connect ...'
			for: self
			do: [:node | 
				states := self owner states collect: #name.
				index := UIManager default chooseFrom: states.
				index >= 0 ifTrue: [self owner connect: self name to: (states values at: index) if: SBBlockBody empty]]).
		(SBCodeAction labeled: 'Add Enter' for: self do: [:node | node addUponEnter: SBBlockBody empty]).
		(SBCodeAction labeled: 'Add Leave' for: self do: [:node | node addUponLeave: SBBlockBody empty]).
		(SBCodeAction labeled: 'Set Initial' for: self do: [:node | node owner initialState: self])
	}