as yet unclassified
unregisterWatch: aWatch

	self registry at: aWatch identifier ifPresent: [:list |
		list remove: aWatch ifAbsent: [].
		list ifEmpty: [self registry removeKey: aWatch identifier]]