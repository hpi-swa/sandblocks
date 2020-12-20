as yet unclassified
canAdd: aBlock

	aBlock insertCommandRequest: true near: (aBlock childSandblocks ifNotEmpty: #last ifEmpty: [nil])