as yet unclassified
method: aSymbol for: anObject super: supered numArgs: numArgs

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: anObject].
	^ lookupClass lookupSelector: aSymbol