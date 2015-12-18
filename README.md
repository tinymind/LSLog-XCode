# LSLog-XCode
An XCode plugin to filter and colorize the XCode debugging console. It's natively supports XcodeColors. You can customize the log level prefix and log text color.

## Example

![LSLog-XCode](https://github.com/tinymind/LSLog-XCode/raw/master/LSLog-XCode.gif)  

## Features

* Filter console log.
* Filter using regular expression.
* Natively supports XcodeColors.
* Customize the log level prefix. 
* Default log level prefix and color:
  * Error: `<ERROR>`, RGB(214, 57, 30)
  * Warn: `<WARNING>`, RGB(204, 121, 32)
  * Info: `<INFO>`, RGB(32, 32, 32)
  * Verbose: `<VERBOSE>`, RGB(0, 0, 255)

## Notice

* If you are not using XcodeColors, LSLog-XCode will colorize the log text.  

## Installation

* Install via [Alcatraz](https://github.com/alcatraz/Alcatraz) (Coming soon...) 
* Download this project, build & run, and **Restart XCode**.

## Uninstall

LSLog-XCode.xcplugin should be saved in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`, you can uninstall it by removing `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/LSLog-XCode.xcplugin`.

## Requirements

XCode 4, 5, 6 & 7.

## Thanks

* [MCLog](https://github.com/yuhua-chen/MCLog)
* [XcodeColors](https://github.com/robbiehanson/XcodeColors)
