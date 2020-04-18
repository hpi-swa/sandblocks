actions
openClass: aClass

	^ self classes
		detect: [:m | m shownClass = aClass]
		ifFound: [:m | m select; yourself]
		ifNone: [self openMorphInView: (SBClass new class: aClass)]