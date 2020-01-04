as yet unclassified
preFormat: aNode 
	| formatter |
	^ (preFormatCache
		at: aNode
		ifAbsentPut: [formatter := self class new.
			formatter parents: parents.
			formatter indent: indent.
			formatter preFormatCache: preFormatCache copy.
			aNode accept: formatter.
			{formatter contents. indent}]) first