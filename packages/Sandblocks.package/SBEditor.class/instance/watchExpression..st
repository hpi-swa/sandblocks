as yet unclassified
watchExpression: aBlock

	| watch |
	watch := SBWatch new identifier: Random new nextValue.
	aBlock owner replaceSubmorph: aBlock by: watch.
	watch expression: aBlock