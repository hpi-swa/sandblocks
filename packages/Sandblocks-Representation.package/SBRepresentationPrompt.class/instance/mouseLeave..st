as yet unclassified
mouseLeave: anEvent

	SBToggledCode comment: '' active: 1 do: {
		[
			self addAlarm: #delete after: 1 seconds asMilliSeconds]
	}