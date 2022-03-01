example-extracting
keyValuesOfExampleObject: aJsObject

	^ (aJsObject access children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]