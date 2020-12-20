actions
closeAll
	<action>
	
	scroll hasSubmorphs ifTrue: [
		self do: (SBCombinedCommand newWith: (scroll submorphs collect: [:m | SBDeleteCommand newNonEdit target: m]))]