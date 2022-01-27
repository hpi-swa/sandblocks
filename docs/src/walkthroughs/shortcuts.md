# Custom Shortcuts

To register a custom shortcut for your block, do the following:

1. implement a method with the `<action>` pragma
2. implement `registerShortcuts:` on your class
3. run `SBInputMapping updateShortcutProviders`

In more detail:

### (1) Implement an Action

In your block class, implement e.g.,

```
MyBlock>>doubleQuantity
    <action>
    
    self ...
```

### (2) Implement registerShortcuts

On the **class-side** of your block class, implement e.g.,

```
MyBlock class>>registerShortcuts: aProvider
    aProvider registerShortcut: $d command do: #doubleQuantity
```

For a lot of examples on different ways to specify shortcuts, see `SBTextInputMapping>>registerDefaultShortcuts`.

### (3) Update Shortcut Providers

Finally, just do-it `SBInputMapping updateShortcutProviders` once and the shortcut should start working.
