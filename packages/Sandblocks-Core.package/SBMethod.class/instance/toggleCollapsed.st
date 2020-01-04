as yet unclassified
toggleCollapsed

	body
		visible: body visible not;
		disableLayout: body visible not.
	
	(body visible not and: [self isSelected not]) ifTrue: [self select]