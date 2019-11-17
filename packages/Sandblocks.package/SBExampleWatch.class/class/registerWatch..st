as yet unclassified
registerWatch: aWatch

	(self registry at: aWatch identifier ifAbsentPut: [OrderedCollection new]) add: aWatch