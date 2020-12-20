actions
deleteBlock
	<action>
	
	(UIManager default confirm: 'Are sure you want to close the editor?')
		ifTrue: [self close]