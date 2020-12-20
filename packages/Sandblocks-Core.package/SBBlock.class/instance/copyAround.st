actions
copyAround
	<action>

	| replacer editor target |
	" create a copy of our surroundings with ourselves replaced "
	editor := self sandblockEditor.
	target := self parentSandblock.
	editor countModifier - 1 timesRepeat: [target := target parentSandblock].
	
	replacer := SBPastePlaceholder new.
	self replaceBy: replacer.
	editor copyBuffer: target.
	replacer replaceBy: self