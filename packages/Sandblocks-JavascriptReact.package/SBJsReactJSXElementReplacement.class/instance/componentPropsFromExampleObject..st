example-extracting
componentPropsFromExampleObject: aJsObject

	^ aJsObject access children
		detect: [:objectEntry | objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']]
		ifFound: [:objectEntry | objectEntry access value]