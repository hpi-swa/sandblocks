as yet unclassified
preFormat: aNode

	| formatter |
	^ ((SBExampleWatch report: preFormatCache for: 760893879)
		at: aNode
		ifAbsentPut: [
			formatter := self class new.
			formatter parents: parents.
			formatter indent: indent.
			formatter preFormatCache: preFormatCache copy.
			aNode accept: formatter.
			{formatter rawContents. indent. formatter literalLines}]) first