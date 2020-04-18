actions
deleteAroundSelection

	| replacer around |
	" create a copy of our surroundings with ourselves replaced "
	replacer := SBPastePlaceholder new.
	around := self selection.
	around replaceBy: replacer.
	self setCopyBuffer: replacer parentSandblock.
	replacer replaceBy: around.
	
	(self selection isExpression" and: [self selection parentSandblock isExpression]") ifTrue: [
		self do: ((SBReplaceCommand newFor: self method)
			target: self selection parentSandblock;
			replacer: self selection)]