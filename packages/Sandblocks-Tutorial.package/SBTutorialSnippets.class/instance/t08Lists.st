as yet unclassified
t08Lists

	SBLabel text: [
		'Many elements have a variable number of children.
These include Arrays, Blocks and even keyword message sends.

Use . to append an element to a list, use + to insert an element after the selected
and * to insert an element before the selected.'].
	{32. 43. 12}.
	SBLabel text: [
		'Create your own arrays by pressing { on an element. Then press + to add more elements'].
	42.
	SBLabel text: [
		'Change the call to a with:do: with a second array.

Select the first array and press +. Type ''with'' and press tab. Type { to create a new array.
Finally, select the block argument :num and press + to add another binding and adapt the showln:'].
	{42. 12} do: [:num | Transcript showln: num].
	SBLabel text: ['This could be your final result:'].
	{42. 12} with: {54. 32} do: [:num :num2 | Transcript showln: {num. num2}].
	SBLabel text: [
		'One final note for statements: for convenience, o and O will insert statements in the current block.
This allows you to quickly create a new statement, even when you do not have a statement selected.

Try pressing * when you have `42 squared` selected. Select the 42 and press O.'].
	42 squared