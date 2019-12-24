as yet unclassified
collapsed: aBoolean

	body visible not = aBoolean ifTrue: [^ self].
	
	body
		visible: aBoolean not;
		disableLayout: aBoolean.
	
	(aBoolean not and: [self isSelected not]) ifTrue: [self select]