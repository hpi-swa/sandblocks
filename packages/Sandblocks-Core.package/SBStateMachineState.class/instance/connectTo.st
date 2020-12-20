as yet unclassified
connectTo
	<action>

	| states index |
	states := self owner states collect: #name.
	index := UIManager default chooseFrom: states.
	index > 0 ifTrue: [
		self owner connect: self name to: (states values at: index) if: SBBlockBody empty]