configuration
defaultColorPolicy

	^ DefaultColorPolicy ifNil: [DefaultColorPolicy := SBColorMinimalPolicy]