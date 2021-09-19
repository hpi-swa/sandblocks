Class {
	#name : #SBTreeSitter,
	#superclass : #ExternalLibrary,
	#instVars : [
		'currentString'
	],
	#category : #'Sandblocks-TreeSitter-FFI'
}

{ #category : #'as yet unclassified' }
SBTreeSitter class >> moduleName [

	^ 'tree-sitter'
]

{ #category : #ffi }
SBTreeSitter >> cursor: aCursor reset: aNode [

	<apicall: void ts_tree_cursor_reset (SBTSTreeCursor* SBTSNode)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorCopy: aCursor [

	<apicall: SBTSTreeCursor ts_tree_cursor_copy (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorCurrentNode: aCursor [

	<apicall: SBTSNode ts_tree_cursor_current_node (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorDelete: aCursor [

	<apicall: void ts_tree_cursor_delete (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorGotoFirstChild: aCursor [

	<apicall: bool ts_tree_cursor_goto_first_child (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorGotoNextSibling: aCursor [

	<apicall: bool ts_tree_cursor_goto_next_sibling (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorGotoParent: aCursor [

	<apicall: bool ts_tree_cursor_goto_parent (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> cursorNew: root [

	<apicall: SBTSTreeCursor ts_tree_cursor_new (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'ffi languages' }
SBTreeSitter >> json [

	<apicall: void* tree_sitter_json () module: 'tree-sitter-json'>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> node: aNode childByFieldName: aString length: aNumber [

	<apicall: SBTSNode ts_node_child_by_field_name (SBTSNode char* uint32_t)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> nodeEndByte: aNode [

	<apicall: uint32_t ts_node_end_byte (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> nodeParent: aNode [

	<apicall: SBTSNode ts_node_parent (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> nodeStartByte: aNode [

	<apicall: uint32_t ts_node_start_byte (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> nodeString: aNode [

	<apicall: char* ts_node_string (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> nodeType: aNode [

	<apicall: char* ts_node_type (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parse: aString language: aSymbol factory: aFactory [

	| language parser root tree block cursor |
	currentString := aString withUnixLineEndings.
	language := self perform: aSymbol.
	
	parser := self parserNew.
	self parser: parser setLanguage: language.
	
	tree := self parser: parser old: nil parseString: currentString length: currentString size.
	
	root := self treeRootNode: tree.
	cursor := self cursorNew: root.
	
	block := ((SBInlineBlockSymbol new type: (self nodeType: root) factory: aFactory) takeParsedFrom: (SBTSCursor new library: self cursor: cursor factory: aFactory))
		hResizing: #rigid;
		attachDecorator: SBResizableDecorator new;
		updateAllHighlights.
	
	self nodeString: root.
	
	self cursorDelete: cursor.
	self parserDelete: parser.
	
	^ block
]

{ #category : #ffi }
SBTreeSitter >> parser: aParserPointer old: aTreePointer parseString: aString length: aNumber [

	<apicall: void* ts_parser_parse_string (void* void* char* uint32_t)> 
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> parser: aParserPointer setLanguage: aLanguagePointer [

	<apicall: void ts_parser_set_language (void* void*)> 
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> parserDelete: aCursor [

	<apicall: void ts_parser_delete (void*)>
	^ self externalCallFailed
]

{ #category : #ffi }
SBTreeSitter >> parserNew [

	<apicall: void* ts_parser_new ()> 
	^ self externalCallFailed
]

{ #category : #helper }
SBTreeSitter >> printTree: aCursor factory: aFactory [

	| node type |
	node := self cursorCurrentNode: aCursor.
	type := self nodeType: node.
	
	Transcript showln: type.
	
	(self cursorGotoFirstChild: aCursor) ifTrue: [
		self printTree: aCursor factory: aFactory.
		[self cursorGotoNextSibling: aCursor] whileTrue: [self printTree: aCursor factory: aFactory].
		self cursorGotoParent: aCursor]
]

{ #category : #'ffi languages' }
SBTreeSitter >> python [

	<apicall: void* tree_sitter_python () module: 'tree-sitter-python'>
	^ self externalCallFailed
]

{ #category : #helper }
SBTreeSitter >> textForNode: aNode [
	" TODO: will break with UTF-8 "

	^ currentString copyFrom: (self nodeStartByte: aNode) + 1 to: (self nodeEndByte: aNode)
]

{ #category : #ffi }
SBTreeSitter >> treeRootNode: aTree [

	<apicall: SBTSNode ts_tree_root_node (void*)>
	^ self externalCallFailed
]
