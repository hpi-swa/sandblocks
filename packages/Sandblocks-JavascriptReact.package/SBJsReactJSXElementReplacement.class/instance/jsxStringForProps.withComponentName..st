example-extracting
jsxStringForProps: aCollectionOfKeyValuePairs withComponentName: aString

	^ String streamContents: [:stream |
		stream
			nextPutAll: '<';
			nextPutAll: aString.
		aCollectionOfKeyValuePairs do: [:association |
			stream
				space;
				nextPutAll: association key;
				nextPutAll: '={';
				nextPutAll: association value sourceString;
				nextPutAll: '}'].
		stream
			space;
			nextPutAll: '/>']