as yet unclassified
activeErrorDo: aBlock

	self submorphs detect: [:m | m expanded] ifFound: aBlock