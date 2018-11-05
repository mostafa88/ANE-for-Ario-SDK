# Ait Native Extension(ANE) library for Ario SDK

An AIR Native Extension for Ario SDK that used by Adobe Air developers.

# Project Structore
\AioTest
\ArioANE
\ArioANE-native


# Building 
In project propertice >> actionScript LIbrary Compiler >>  Additional compiler arguments:
add the following flag "-swf-version 13".

1- first build `ArioANE-native` project in visual studio 2015 in release mode.
2- run `\ArioANE\build-ane-libarary.bat` 
3- start coding in `AioTest\` project

# References
It is a complte refrence to start understanding adobe Air and build first adobe air project
1-https://help.adobe.com/en_US/air/build/air_buildingapps.pdf

A good tutorial by example that show you how to work with a adobe air project and code action script
2-https://www.tutorialspoint.com/flex/flex_quick_guide.htm

Developing Native Extensions: A comprehensive document to building ANE library
3-https://help.adobe.com/en_US/air/extensions/index.html

Adding external dll dependency to ANE library (3rd party dll library)
4-https://stackoverflow.com/q/9823504/1789669

A good, complete and step by step tutorial to building ANE for windows application.
5- http://easynativeextensions.com/windows-tutorial-introduction/
