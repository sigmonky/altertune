# altertune
An Application for Exploring Alternate Scale Tunings Using AudioKit

This application is a quick prototype for exploring a couple of different ways to explore features of a paritcular scale tuning.
The current emphasis is on what are known as just intonation scales. All scale members in such a scale can be described using a whole number fraction that indicates their frequency relationship to the root note, described as 1/1. For example, a scale member designated as 3/2 indicates that it vibrates at 1.5 times the frequency of the root, i.e. 1/1. 

Currently the app enables you to pluck individual notes, repeat selected note group as a drone, and repeast selected note groups in a groove. The groove option will play each note at a tempo relative to the root that reflects its frequency ratio to root. For example, the note 2/1 will be played 2 times for each individual playback of 1/1.

I intend to iterate on this project and provide more features over time. The current iteration was developed in about 3 hours for a presentation to an iOS Special Interest Group on Functional Programming in Swift. This prototype was intended to demonstrate how functional-oriented programming features in AudioKit facilitated algorithmic composition. 

Currently the project only enables exploring two scales. The "European" scale is a 5-limit just intonation version of the familiar major diatonic scale. The "Ancient" scale is an enharmonic 31-limit just intonation scale presumably of ancient Greek vintage... but who knows really? This limitation will be addressed soon. The project includes a library of over 3000 scale tunings rendered in JSON format and derived from scala tuning files used with the scala music app. NOTE: this scala app has NOTHING to do with the Scala language. The fundamental logic for quickly rendering a just intonation scale is already in place. But I need to figure out a way to present the vast catalog of scales already available. 
