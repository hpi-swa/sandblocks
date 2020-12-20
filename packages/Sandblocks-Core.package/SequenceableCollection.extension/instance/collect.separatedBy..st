*Sandblocks-Core
collect: elementBlock separatedBy: separatorBlock

	^ self species streamContents: [:stream |
		1 to: self size do: [:index |
			index = 1 ifFalse: [stream nextPut: separatorBlock value].
			stream nextPut: (elementBlock value: (self at: index))]]