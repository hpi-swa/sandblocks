actions
toggleFullscreen
	<action>

	self owner = self world
		ifTrue: [
			(self valueOfProperty: #previousWindow) addMorph: self frame: (0@0 extent: 1@1).
			self removeProperty: #previousWindow]
		ifFalse: [
			self
				setProperty: #previousWindow toValue: self owner;
				openInWorld;
				extent: Display extent;
				position: 0 @ 0]