as yet unclassified
noteSpecialSelector: selectorSymbol
	" override to make sure we do not transform to special macros, which messes up our source code transforms (empty line markers) "
	special := 0