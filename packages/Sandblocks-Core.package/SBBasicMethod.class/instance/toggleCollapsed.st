as yet unclassified
toggleCollapsed
	<action>

	self body
		visible: self body visible not;
		disableLayout: self body visible not.
	
	(self body visible not and: [self isSelected not and: [self sandblockEditor notNil]]) ifTrue: [self select]