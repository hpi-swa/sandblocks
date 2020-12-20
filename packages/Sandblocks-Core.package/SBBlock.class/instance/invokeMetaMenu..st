as yet unclassified
invokeMetaMenu: anEvent

	SBLabel text: [
		'We hijack this event because it''s the only way to cleanly access ctrl+click'].
	self pickUp: anEvent