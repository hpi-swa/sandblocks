helper
showHelper

	(helpOverlay isNil and: [self isInWorld and: [self selection notNil]]) ifTrue: [helpOverlay := SBHelpOverlay new target: self selection]