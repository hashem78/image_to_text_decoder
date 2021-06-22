# image_to_text_decoder
## _Decode text/code easily on windows/linux_

image_to_text_decoder is a simple flutter application that calls an AWS lambda function, which uses aws textract itself, to decode screenshots of code/text and turn them to usable text.

## Features
- Supports windows/linux
- Select a folder to track screenshot creation.
- Append decoded text to a file.
- Ability to check if text is palagrized using the Standford university palegrization checker\*.
- Typewrite decoded text/text from clipboard\*\*
    - speed of typewriting is controllable
    - delay to start decoding can be set
- Audiable cues are fired on success/failure (on windows only).
- Remove extra bracket pairs while typewriting on editor auto-insert closing pairs by default

## Usage
    1- Download a suitable binary zip file for your system from the downloads section.

    2- Run the application as you'd run any executable.
    
- Inorder for the decoding to work you'll need to set a valid screenshotting path;this folder is tracked for creation changes so make sure it's the same directory/folder where your screenshotting program sends its captures and make sure you have read/write permissions.

\*If you want to use MOSS functionality you'll have to supply your own .perl script in the root folder of where you extracted your binaries, get MOSS from this link https://theory.stanford.edu/~aiken/moss/ and you need to make sure perl is installed on your system.

## Using the typewritier
- \*\*Typewriting unfortunately works on windows only right now.
- Typewriting is useful when copy/paste are not available.
- Once an image is decoded the option to typewrite its content becomes available (you can typewrite from the clipboard regradless).

        1- Adust the typewriting delay, which is the delay before the system registers key events, to your desire.

        2- Adjust the typewriting speed, which is the time between each individual keyevent.

        3- Start the typewriter by clicking the relative button.

        4- Type writing can be stopped once started.

## Building
    1- Install flutter

    2- Clone repo

    3- flutter build [platform]

## WIP
- Better documentation.
- Integrate MOSS as a dart/python script rather than using system calls.


# Screenshots

![](https://i.imgur.com/HeebhIC.png)
![](https://i.imgur.com/n30jRQI.png)