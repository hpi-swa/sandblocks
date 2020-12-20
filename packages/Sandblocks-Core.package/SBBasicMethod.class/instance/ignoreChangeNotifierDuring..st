as yet unclassified
ignoreChangeNotifierDuring: aBlock

	self setProperty: #ignoreChangeNotifier toValue: true.
	
	aBlock ensure: [self removeProperty: #ignoreChangeNotifier]