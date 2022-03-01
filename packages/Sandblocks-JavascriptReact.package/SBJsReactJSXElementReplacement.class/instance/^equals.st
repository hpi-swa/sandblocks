comparing
= aComponentUsageReplacement

	self componentName ifNil: [^ super = aComponentUsageReplacement].
	^ aComponentUsageReplacement class = self class and: [aComponentUsageReplacement componentName = self componentName]