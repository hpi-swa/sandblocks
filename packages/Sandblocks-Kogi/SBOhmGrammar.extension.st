Extension { #name : #SBOhmGrammar }

{ #category : #'*Sandblocks-Kogi' }
SBOhmGrammar >> blocklyHtmlFrom: anOriginalGrammar [

	| rules |
	rules := self childSandblocks select: [:r | SBToggledCode comment: '' active: 1 do: {[true]. [r isLexical not]}].
	^ '<meta charset="utf-8">
<script src="https://unpkg.com/blockly/blockly.min.js"></script>
<div id="blocklyDiv" style="height: 480px; width: 800px;"></div>

<xml id="toolbox">
	{1}
	{4}
</xml>
<script>
	{2}
	{3}
	Blockly.Blocks[''rubber''] = \{
		init: function() \{
    		this.setPreviousStatement(true, null);
			this.setNextStatement(true, null);
			this.appendValueInput("NAME");
 		\}
	\}
</script>

<script>
Blockly.BlockSvg.START_HAT = true;
var workspace = Blockly.inject(''blocklyDiv'', \{
	toolbox: document.getElementById(''toolbox''),
	collapse: true,
	toolboxPosition: ''start'',
	trashcan: true
\});
</script>' format: {
		(rules collect: [:rule | rule toolboxDeclarationFrom: anOriginalGrammar]) joinSeparatedBy: String cr.
		(rules collect: [:rule | rule blockDeclarationFrom: anOriginalGrammar]) joinSeparatedBy: String cr.
		self jsFieldToggle.
		(self needsStatementRubberFrom: anOriginalGrammar)
			ifTrue: ['<category name="Stmt to Expr"><block type="rubber"></block></category>']
			ifFalse: ['']}
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmGrammar >> jsFieldToggle [

	^ '// https://github.com/google/blockly-samples/blob/master/plugins/block-plus-minus/src/field_minus.js
const minusImage =    ''data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAw'' +    ''MC9zdmciIHZlcnNpb249IjEuMSIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48cGF0aCBkPS'' +    ''JNMTggMTFoLTEyYy0xLjEwNCAwLTIgLjg5Ni0yIDJzLjg5NiAyIDIgMmgxMmMxLjEwNCAw'' +
    ''IDItLjg5NiAyLTJzLS44OTYtMi0yLTJ6IiBmaWxsPSJ3aGl0ZSIgLz48L3N2Zz4K'';

// https://github.com/google/blockly-samples/blob/master/plugins/block-plus-minus/src/field_plus.js
const plusImage =    ''data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC'' +    ''9zdmciIHZlcnNpb249IjEuMSIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48cGF0aCBkPSJNMT'' +    ''ggMTBoLTR2LTRjMC0xLjEwNC0uODk2LTItMi0ycy0yIC44OTYtMiAybC4wNzEgNGgtNC4wNz'' +    ''FjLTEuMTA0IDAtMiAuODk2LTIgMnMuODk2IDIgMiAybDQuMDcxLS4wNzEtLjA3MSA0LjA3MW'' +    ''MwIDEuMTA0Ljg5NiAyIDIgMnMyLS44OTYgMi0ydi00LjA3MWw0IC4wNzFjMS4xMDQgMCAyLS'' +
    ''44OTYgMi0ycy0uODk2LTItMi0yeiIgZmlsbD0id2hpdGUiIC8+PC9zdmc+Cg=='';

const FieldToggle = function(message, args, min, max, opt_validator) {
  FieldToggle.superClass_.constructor.call(this, plusImage, 15, 15, undefined, function(field) {
    const block = field.getSourceBlock();
    if (block.isInFlyout) {
      return;
    }

    Blockly.Events.setGroup(true);
	const oldMutation = Blockly.Xml.domToText(block.mutationToDom());
    block.add(message, args, min, max, field.getParentInput(), field);
    const newMutation = Blockly.Xml.domToText(block.mutationToDom());



    if (oldMutation != newMutation) {

      Blockly.Events.fire(new Blockly.Events.BlockChange(

          block, ''mutation'', null, oldMutation, newMutation));

    }

    Blockly.Events.setGroup(false);

  });

};



FieldToggle.fromJson = function(options) {

  var message = Blockly.utils.replaceMessageReferences(options[''message'']);

  var args = Blockly.utils.replaceMessageReferences(options[''args'']);

  var min = Blockly.utils.replaceMessageReferences(options[''min'']);

  var max = Blockly.utils.replaceMessageReferences(options[''max'']);

  return new FieldToggle(message, args, min, max);

};



Blockly.fieldRegistry.register(''field_toggle'', FieldToggle);

Blockly.utils.object.inherits(FieldToggle, Blockly.FieldImage);



Blockly.Extensions.registerMutator(''optional_mutator'', {

  props: {},



  mutationToDom: function() {

    const container = Blockly.utils.xml.createElement(''mutation'');

    container.setAttribute(''props'', JSON.stringify(this.props));

    return container;

  },

  domToMutation: function(xmlElement) {

    this.props = JSON.parse(xmlElement.getAttribute(''props'')) || {};

    for (const name in this.props) {

      const props = this.props[name];

      const count = props.count;

      props.count = 0;

      this.setCount(props.referenceFieldName, count, props.message, props.args, props.blockBeforeName, props.min, props.max);

      props.count = count;

    }

  },

  add: function(message, args, min, max, insertAfter, referenceField) {

    let props = this.props[referenceField.name];

    if (!props) {

      props = this.props[referenceField.name] = {

        count: 0,

        referenceFieldName: referenceField.name,

        blockBeforeName: insertAfter.name,

        message,

        args,

        min,

        max,

      };

    }



    if (props.count >= max)

      return;

    this.setCount(referenceField.name, props.count + 1, message, args, insertAfter.name, min, max);

    props.count++;

    this.render();

  },

  remove: function(message, args, min, max, insertAfter, referenceField) {

    const props = this.props[referenceField.name];

    if (props.count < 1)

      return;

    this.setCount(referenceField.name, props.count - 1, message, args, insertAfter.name, min, max);

    props.count--;

    this.render();

  },

  setCount: function(blockName, count, message, args, blockBeforeName, min, max) {

    const current = this.props[blockName].count;

    const repeat = count - current;

    const referenceField = this.getField(this.props[blockName].referenceFieldName);

    const insertAfter = this.getInput(blockBeforeName);



    if (repeat > 0) {

      for (let i = 0; i < repeat; i++) {

        const currentElements = [...this.inputList];

        this.interpolate_(message, args.map(arg => ({...arg, name: arg.name + ''_'' + (current + i)})));

        const newElements = this.inputList.filter(i => !currentElements.includes(i));

        let index = this.inputList.findIndex(i => i.name === blockBeforeName) + 1;

        for (const newEl of newElements) {

          newEl.name ||= ''GENERATED_'' + blockName + ''_'' + (current + i);

          this.moveNumberedInputBefore(this.inputList.indexOf(newEl), index);

        }

      }



      if (count === max) {

        referenceField.setVisible(false);

      }



      if (current === 0) {

        let self = this;

        const field = new Blockly.FieldImage(minusImage, 15, 15, undefined, function(field) {

          self.remove(message, args, min, max, insertAfter, referenceField);

        });

        insertAfter.insertFieldAt(insertAfter.fieldRow.indexOf(referenceField), field, ''REMOVE_'' + referenceField.name);

      }

    } else if (repeat < 0) {

      // const last = inputList.reversed().find(input => input.name.startsWith(blockName + ''_''));

      for (let i = 0; i < -repeat; i++) {

        for (const arg of [...args, {name: ''GENERATED''}]) {

          const name = arg.name + ''_'' + (current - 1 - i)

          if (this.inputList.find(i => i.name === name)) {

            this.removeInput(name);

          }

        }

      }

      referenceField.setVisible(true);

      if (count <= 0) {

        insertAfter.removeField(''REMOVE_'' + referenceField.name);

      }

    }

  },

}, function() { false && this.initShape(false); });'
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmGrammar >> needsStatementRubberFrom: anOriginalGrammar [

	self allBlocksDo: [:b | (b isIdentifier and: [b parentSandblock isRepeatQuantifier and: [b isSimple not and: [(b associatedRule kogiOutputFrom: anOriginalGrammar) = 'input_value']]]) ifTrue: [^ true]].
	^ false
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmGrammar >> openBlocklyFrom: anOriginalGrammar [

	| file |
	file := (FileDirectory default / 'blocky-test.html') fullName.
	FileStream
		forceNewFileNamed: file
		do: [:f | f nextPutAll: (self blocklyHtmlFrom: anOriginalGrammar) withUnixLineEndings].
	ExternalWebBrowser openOnUrl: 'file://', file
]
