#!/usr/bin/env python3

import signal
import sys
import time
from pynput import mouse
from pynput import keyboard
from pynput.keyboard import Key

has_secondary = '--sb' not in sys.argv

# diambiguate backspace for edit vs for mistake?

navigation = 0
deleting = 0
input = 0
commands = 0
clicks = 0
secondary = 0

modifier_count = 0
ctrl_pressed = False
modifiers = [Key.ctrl_l, Key.ctrl_r, Key.cmd_l, Key.cmd, Key.cmd_r, Key.alt, Key.alt_gr, Key.alt_l, Key.alt_r]
ctrl_keys = [Key.ctrl_l, Key.ctrl_r, Key.ctrl]

# TODO:
# control+z
# dump entire history in file

time_per_part = []
start_time = None

def print_results():
    global start_time
    print('{0}{1}{2}'.format('\033[1m', '\n\n\n\n========\nRESULTS:\n========\n', '\033[0m'))
    print('Navigation:\t{0}\nDeleting:\t{1}\nInput:\t\t{2}\nCommands:\t{3}\nClicks:\t\t{4}'.format(navigation, deleting, input, commands, clicks))
    if has_secondary:
        print('Secondary:\t{0}'.format(secondary))

    print("\nTotal:\t\t{0}".format(navigation + deleting + input + commands + secondary))
    print("\nTime:")
    i = 1
    for t in time_per_part:
        print("\tPart {0}: {1}s".format(i, t))
        i = i + 1
    print("\nTotal: {0}s".format(sum(time_per_part)))
    print()

def signal_handler(sig, frame):
    print_results()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def print_cat(cat):
    print(cat)
    pass

def on_click(x, y, button, pressed):
    global clicks
    clicks = clicks + 1
    print_cat('click')

def on_press(key):
    global navigation, deleting, input, commands, secondary, ctrl_pressed, modifier_count

    # our special shortcut that shouldn't be counted
    if key == Key.enter and ctrl_pressed:
        if not next_part():
            print_results()
            return False
        else:
            return

    # ignore modifiers without a key
    if key in modifiers:
        modifier_count = modifier_count + 1
        if key in ctrl_keys:
            ctrl_pressed = True
        return
    if key in [Key.shift, Key.shift_l, Key.shift_r]:
        return

    # even with modifiers, these are navigation commands
    if key in [Key.left, Key.right, Key.up, Key.down, Key.home, Key.end, Key.page_up, Key.page_down]:
        navigation = navigation + 1
        print_cat("Navigation")
        return

    # even with modifiers, these are navigation commands
    if key in [Key.backspace, Key.delete]:
        deleting = deleting + 1
        print_cat("Deleting")
        return

    if modifier_count > 0:
        commands = commands + 1
        print_cat("Command")
        return

    if key in [Key.space, Key.tab]:
        if has_secondary:
            secondary = secondary + 1
            print_cat("Secondary")
        else:
            input = input + 1
            print_cat("Input")
        return

    if key == Key.enter:
        input = input + 1
        print_cat("Input")
        return

    try:
        key.char
        input = input + 1
        print_cat("Input")
        # print('alphanumeric key {0} pressed'.format(key.char))
    except AttributeError:
        print('/!\ special key {0} pressed'.format(key))

def on_release(key):
    global modifier_count, ctrl_pressed
    if key in modifiers:
        modifier_count = modifier_count - 1
        if key in ctrl_keys:
            ctrl_pressed = False
        return

def print_part(p, num):
    print('{0}{1}{2}'.format('\033[1m', '\n\n\n\n=======\nTASK {0}:\n=======\n'.format(num), '\033[0m'))
    for l in p.splitlines():
        if l[0] == '-':
            print('{0}{1}{2}'.format('\033[31m', l, '\033[0m'))
        elif l[0] == '+':
            print('{0}{1}{2}'.format('\033[32m', l, '\033[0m'))
        else:
            print(l)

current_part = -1
def next_part():
    global current_part, start_time

    if not start_time:
        start_time = time.time()
    else:
        now = time.time()
        time_per_part.append(now - start_time)
        start_time = now

    current_part = current_part + 1
    if current_part >= len(parts):
        return False

    print_part(parts[current_part], current_part + 1)
    return True

parts = [
''' { #category : #'initialization' }
 Observable >> initialize [
 
-   listeners := OrderedCollection new
+   listenerMap := Dictionary new
 ]''',
''' { #category : #'accessing' }
-Observable >> listeners [
+Observable >> listenerMap [
 
-   ^ listeners
+   ^ listenerMap
 ]''',
''' { #category : #'observer' }
-Observable >> listen: anObject [
+Observable >> listen: anObject for: aString [
 
-   self listeners add: anObject.
+   | sub |
+   sub := Subscription new.
+   (self listenerMap
+       at: aString
+       ifAbsentPut: [Dictionary new]) add: sub -> anObject.
+   ^ sub
 ]''',
''' { #category : #'observer' }
-Observable >> notify [
+Observable >> notify: aTopicString [
 
-   self listeners do: [:listener | listener notify]
+   (self listenerMap at: aTopicString)
+       keysAndValuesDo: [:sub :listener | listener notify]
 ]''',
''' { #category : #'observer' }
-Observable >> removeSubscription: anObject [
+Observable >> removeSubscription: aSubscription [
 
-   self listeners removeAllSuchThat: [:listener | listener ~= anObject]
+   self listenerMap valuesDo: [:listener |
+       listener at: aSubscription ifPresent: [listener removeKey: aSubscription]]
 ]''',
''' { #category : #'example' }
@@ -44,7 +48,13 @@ Observable >> example [
    observable := Observable new.
    observer := Object new.
 
-   observable notify: #test.
+   observable notify: #test1.
+   observable notify: #test2.
 
-   observable listen: observer.
+   sub := observable listen: observer for: #test1.
+   observer onDelete: [
+       observable removeSubscription: sub].
+
+   observable notify: #test1.
 ]''',
]

mouse_listener = mouse.Listener(
    on_click=on_click)
mouse_listener.start()

next_part()

with keyboard.Listener(
    on_press=on_press,
    on_release=on_release) as key_listener:
    key_listener.join()

# key_listener.join()
