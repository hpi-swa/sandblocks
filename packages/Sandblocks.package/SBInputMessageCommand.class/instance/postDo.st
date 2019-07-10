as yet unclassified
postDo

	editInputIndex ifNotNil: [
		select sandblockEditor startInput: select at: 1 replacingContents: false.
		select signature focusPartAt: editInputIndex]