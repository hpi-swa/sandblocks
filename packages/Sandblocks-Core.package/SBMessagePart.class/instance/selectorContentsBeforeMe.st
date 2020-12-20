as yet unclassified
selectorContentsBeforeMe

	^ self messageSend messageParts in: [:parts |
		((parts copyFrom: 1 to: (parts indexOf: self) - 1) collect: #contents) joinSeparatedBy: '']