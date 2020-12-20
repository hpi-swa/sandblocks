as yet unclassified
debugStoreString

	^ SBFormatter
		formatString: (String streamContents: [:stream | self storeOn: stream])
		class: nil class
		noPattern: true