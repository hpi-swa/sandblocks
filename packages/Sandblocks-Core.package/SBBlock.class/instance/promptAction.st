actions
promptAction
	<multiSelectAction>
	<inputAction>

	| options index |
	options := self validActions.
	index := UIManager default chooseFrom: (options collect: [:option |
		option method selector, (' ', (SBEditor shortcutStringForAction: option selector))]).
	index > 0 ifTrue: [self performAction: (options at: index) method selector]