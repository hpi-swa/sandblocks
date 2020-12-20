as yet unclassified
representAs
	<action>

	| options prompt |
	options := self object representationsThat: self acceptedRepresentation.
	options ifEmpty: [^ self].
	
	prompt := SBRepresentationPrompt new options: options target: self object current: self.
	self sandblockEditor openMorphInView: prompt.
	prompt position: self topRight