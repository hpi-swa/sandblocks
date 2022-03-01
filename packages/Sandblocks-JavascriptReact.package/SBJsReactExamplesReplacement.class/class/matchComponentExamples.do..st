inline-replacement
matchComponentExamples: aDictWithBlockCaptures do: aBlock
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
	(class_heritage
		(member_expression
			object: (identifier) ="React"
			property: (identifier) ="Component"
		)
	)
    body: (class_body
	(field_definition
        	(property_identifier) ="sharedExampleProps"
	      (object)
        )? @shared_example_props
    	(field_definition
        	(property_identifier) ="examples"
	      (array) @example_array
        ) @example_array_declaration
	(method_definition
        	(property_identifier) ="render"
  	) @render_method
    )
) @class'>

	^ aBlock
		value: (aDictWithBlockCaptures at: 'example_array_declaration')
		value: (self new examplesFor: aDictWithBlockCaptures)