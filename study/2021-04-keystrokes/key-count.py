#!/usr/bin/env python3

import subprocess
import signal
import sys
import time
import os.path
from pynput import mouse
from pynput import keyboard
from pynput.keyboard import Key, KeyCode
from math import sqrt

condition = sys.argv[-1]
if not condition.startswith('vs') and not condition.startswith('sb') and not condition == 'test':
    print('use with [vs1|vs2|sb1|sb2|test]')
    sys.exit(1)

is_test = condition == 'test'
use_images = condition.startswith('sb')
has_secondary = is_test or condition.startswith('vs')

out_name = condition + '.csv'
if not is_test and os.path.isfile(out_name):
    print("{0} already exists, did you enter the right setup prefix?".format(out_name))
    sys.exit(0)
out = open(out_name, 'w')

# diambiguate backspace for edit vs for mistake?

counts = {}

def count(category, detail):
    if not recording:
        return

    if category not in counts:
        counts[category] = 1
    else:
        counts[category] += 1
    print_cat(category, detail)

recording = False
modifier_count = 0
last_mouse_pos = (0, 0)
ctrl_pressed = False
modifiers = [Key.ctrl_l, Key.ctrl_r, Key.ctrl, Key.cmd_l, Key.cmd, Key.cmd_r, Key.alt, Key.alt_gr, Key.alt_l, Key.alt_r]
ctrl_keys = [Key.ctrl_l, Key.ctrl_r, Key.ctrl]

# TODO:
# control+z

time_per_part = []
start_time = None

def print_twice(s):
    print(s)
    out.write(s + '\n')

def print_results():
    global start_time

    print_twice('\n')
    print('{0}{1}{2}'.format('\033[1m', '\n\n\n========\nRESULTS:\n========\n', '\033[0m'))
    for category, count in counts.items():
        print_twice('{0}{1}\t{2}'.format(category, '\t' if len(category) < 8 else '', count))
    # print_twice('Navigation:\t{0}\nDeleting:\t{1}\nInput:\t\t{2}\nCommands:\t{3}\nClicks:\t\t{4}'.format(navigation, deleting, input, commands, clicks))
    #if has_secondary:
    #    print_twice('Secondary:\t{0}'.format(secondary))

    print_twice("\nTotal:\t\t{0}".format(sum(counts.values())))
    print_twice("\nTime:")
    i = 1
    for t in time_per_part:
        print_twice("\tPart {0}: {1}s".format(i, t))
        i = i + 1
    print_twice("\nTotal: {0}s".format(sum(time_per_part)))
    print()
    out.close()

def signal_handler(sig, frame):
    print_results()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def print_cat(cat, key):
    s = '{0},{1},{2}'.format(time.time(), key, cat)
    out.write(s + '\n')
    if is_test:
        print(s)

def on_click(x, y, button, pressed):
    global last_mouse_pos
    if pressed:
        last_mouse_pos = (x, y)
    else:
        dx = last_mouse_pos[0] - x
        dy = last_mouse_pos[1] - y
        if sqrt(dx * dx + dy * dy) > 25:
            count('drag', button)
        else:
            count('click', button)

def on_press(key):
    global modifier_count, ctrl_pressed
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

    # on linux, this is alt+gr for some reason, ignore it entirely
    if key == KeyCode(65027) or key == KeyCode(65032):
        return

    # even with modifiers, these are navigation commands
    if key in [Key.left, Key.right, Key.up, Key.down, Key.home, Key.end, Key.page_up, Key.page_down]:
        count('navigation', key)
        return

    # even with modifiers, these are navigation commands
    if key in [Key.backspace, Key.delete]:
        count('deleting', key)
        return

    if modifier_count > 0:
        if hasattr(key, 'char') and key.char == 'z':
            count('undo', key)
        else:
            count('command', key)
        return

    if key == Key.esc:
        count('command', key)
        return

    if key in [Key.space, Key.tab]:
        if has_secondary:
            count('secondary', key)
        else:
            count('input', key)
        return

    if key == Key.enter:
        count('input', key)
        return

    try:
        key.char
        count('input', key)
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
    if p.startswith('image:'):
        bashCommand = "kitty +kitten icat ../" + p[len('image:'):]
        process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
        output, error = process.communicate()
    else:
        for l in p.splitlines():
            if len(l) > 0 and l[0] == '-':
                print('{0}{1}{2}'.format('\033[31m', l, '\033[0m'))
            elif len(l) > 0 and l[0] == '+':
                print('{0}{1}{2}'.format('\033[32m', l, '\033[0m'))
            else:
                print(l)

current_part = -1
def next_part():
    global current_part, start_time, recording

    recording = True

    if not start_time:
        start_time = time.time()
    else:
        now = time.time()
        time_per_part.append(now - start_time)
        start_time = now

    current_part = current_part + 1
    if current_part >= len(parts):
        return False

    out.write('---- Part {0} ---\n'.format(current_part + 1))
    print_part(parts[current_part], current_part + 1)
    return True

parts1 = ['image:obs-part1.png', 'image:obs-part2.png', 'image:obs-part3.png', 'image:obs-part4.png', 'image:obs-part5.png', 'image:obs-part6.png'] if use_images else [
''' { #category : #'initialization' }
 Observable >> initialize [

-   listeners := OrderedCollection new
+   listenerMap := Dictionary new
 ]''',
''' { #category : #'observer' }
-Observable >> listen: anObject [
+Observable >> listen: anObject for: aString [

-   self listeners add: anObject.
+   | sub |
+   sub := Notification new.
+   (self listenerMap
+       at: aString
+       ifAbsentPut: [Dictionary new]) add: sub -> anObject.
+   ^ sub
 ]''',
''' { #category : #'observer' }
-Observable >> listeners [
+Observable >> listenerMap [

-   ^ listeners
+   ^ listenerMap
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

-   listeners removeAllSuchThat: [:listener | listener ~= anObject]
+   listenerMap valuesDo: [:listener |
+       listener at: aSubscription ifPresent: [listener removeKey: aSubscription]]
 ]''',
''' { #category : #'example' }
Observable >> example [
    observable := self class new.
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

parts2 = ['image:sort-part1.png', 'image:sort-part2.png'] if use_images else [
'''Sort >> partition: aCollection low: aLowNumber high: aHighNumber [
    | pivot i |
    pivot := aCollection at: aHighNumber.
    i := aLowNumber - 1.
    aLowNumber to: aHighNumber - 1 do: [:j |
        (aCollection at: j) <= pivot ifTrue: [
            i := i + 1.
            aCollection swap: i with: j]].
    aCollection swap: i + 1 with: aHighNumber.
    ^ i + 1
]''',
'''Sort >> quicksort: aCollection low: aLowNumber high: aHighNumber [

    aLowNumber < aHighNumber ifTrue: [ | p |
        p := self partition: aCollection low: aLowNumber high: aHighNumber.
        self quicksort: aCollection low: aLowNumber high: p - 1.
        self quicksort: aCollection low: p + 1 high: aHighNumber].
    ^ aCollection
]''',
]
parts_test = [
    'Please enter the square bracket [, then hit ctrl+alt+enter',
    'Please enter the round bracket (, then hit ctrl+alt+enter',
    'Please use your usual undo combination Cmd+z, then hit ctrl+alt+enter',
    'Please type "The quick brown fox" and hit backspace a couple of times, then hit ctrl+alt+enter',
    'Please enter the asterisk *, then hit ctrl+alt+enter',
    'Please cmd/ctrl and the asterisk (<cmd+*>), then hit ctrl+alt+enter',
    'Please enter the pipe symbol |, then hit ctrl+alt+enter',
]

if is_test:
    print('\n\n\n\nPlease focus any other window than this one.')
    parts = parts_test
    next_part()
elif condition.endswith('1'):
    parts = parts1
elif condition.endswith('2'):
    parts = parts2
else:
    print('invalid test condition')

mouse_listener = mouse.Listener(
    on_click=on_click)
mouse_listener.start()

if not is_test:
    print('This much should fit on one screen:')
    print('----------------------------------------------------------------------------------')

with keyboard.Listener(
    on_press=on_press,
    on_release=on_release) as key_listener:
    key_listener.join()

# key_listener.join()
