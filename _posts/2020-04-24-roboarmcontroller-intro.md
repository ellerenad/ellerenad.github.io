---
layout: post
title:  "RoboArm Controller, part I: Intro and architecture"
date:   2020-04-24T09:25:52+01:00
author: Enrique Llerena Dominguez
categories: learning-machine-learning machine-learning 
tags: deeplearning4j tensorflow java pyhton gazebo architecture roboarm-controller
cover:  "/assets/posts/roboarmcontroller-intro/roboarmcontroller-cover.jpg"
cover_credits: Photo by David Fanuel on Unsplash
---

# Learning Machine Learning Series

This is the first post of a series where I want to describe my journey learning machine learning, a topic I am really
passionate about.

# TL;DR

- The Roboarm Controller is a hobby project I developed to practice different technologies on a ludic way.
- The following technologies were used: Java, Python, C++, Tensorflow, Deeplearning4j, Spring, JUnit, Gazebosim (plus other tools)
- It enables a user to control a simulated robotic arm with the position of their hands.
- It has 3 main components: a simulated robotic arm, a data transformation application, and the hands sensor.
- The machine learning part is on the data transformation: classify the position of the hands to get a movement instruction.
- [Demo][roboarmcontroller_demo]
- [Github repo: ellerenad/RoboArmController][roboarmcontroller_repo]
- The project was presented at the [Java Forum Stuttgart 2019][JFS_roboarmcontroller], and at the EclipseCon Europe 2019 ( [video][eclipsecon_roboarmcontroller_video] / [slides][eclipsecon_roboarmcontroller_slides] )

# RoboArm Controller, part I: Intro and architecture

## Introduction

Some time ago, after having done the MOOC ["Machine Learning for Musicians and Artists"][kadenze_moc] at kadenze, I was eager to apply my knowledge,
so I started to look for a project to get the hands dirty with. It was not an easy task, as a parent I don't really have a lot of time for a side project, maybe just
a couple of hours per week. Requirements are:
- Make me feel passionate about it
- Be an end to end Machine Learning system
- Let me experiment with different technologies in a more ludic way.

Technologies to learn/practice:
- A Machine Learning Framework: Tensorflow, deeplearning4j
- Apache Kafka
- Gazebosim
 
The idea came connecting the dots of previous stuff I had done and seen:
- A simulated robotic arm I made for my masters' thesis
- The [Leap Motion][leap_motion] controller, that I got to know at the above mentioned MOC from Kadenze.


Concretely, the Roboarm Controller allows to control a simulated robotic arm with the position of the hands of a person.
It is a classification problem: We have a bunch of coordinates, representing the position of a hand, and we want to transform that into an instruction, so that:
`Instruction = classify(hand)`, where `Instruction` is something like `Move the servo number 1 applying a positive change`.

<figure>
  <img src="/assets/posts/roboarmcontroller-intro/hands-position-to-instruction.png" alt="Mapping the position of a hand to a instruction"/>
  <figcaption class="image-description">Mapping the position of a hand to a instruction: The left hand (green arrow) indicates which servo to move,
   whereas the right hand (yellow arrow) indicates a positive or negative delta</figcaption>
</figure>



## Evolution of the project

The strategy to achieve the goals were:
1. Do a Minimum Viable Product
1. Do Small iterations to create small pieces with clearly testable deltas
1. Tackle the riskiest things first

I made an initial prototype, where I learned some nice stuff, but I'll leave the evolution to another post.

## Roadmap

Tackle the following challenges:

1. Get data from the sensor
1. Model the simulated robotic arm, control it, and communicate it with the exterior
1. Transform sensor data into movements:  Process data and communicate both components


## Architecture

It has 3 main components:
1. A simulated robotic arm.
1. A hands sensor.
1. A data transformer application.

Note: I don't consider the Machine Learning module as a component, from my perspective it is more a tool used by a component, or even an implementation detail.
I show it here because it is a goal on the project: learn a ML framework.

<figure>
  <img src="/assets/posts/roboarmcontroller-intro/target-architecture.png" alt="Target architecure"/>
  <figcaption class="image-description">Target architecure of the RoboArm Controller.</figcaption>
</figure>

## Brief Description of the components

### Simulated robotic Arm

It is a -rather simple- simulation of a robotic arm, done in [Gazebo][gazebo] , with 3 degrees of freedom. It is controlled by a C++ plugin.
This plugin receives instructions from the exterior on a TCP port, with the format `<servoId delta>`, so the instruction `1 5` 
would move the `servoId: 1` `5` positive degrees.

### Hands Sensor

Used the [Leap Motion][leap_motion] sensor. It has a framework to communicate with different languages, but the way I got to talk 
with it was through a websocket. It provides coordinates for a set of points related to the hands, e.g. the tips of the fingers,
the center of the hand, and so on.

### The data transformer application

It is a Java/Spring Boot application, where the hands' position data is transformed into movement instructions for the simulated robotic arm.



- [Github repo: ellerenad/RoboArmController][roboarmcontroller_repo]
- [Demo of the project](roboarmcontroller_demo)









[roboarmcontroller_repo]: https://github.com/ellerenad/RoboArmController
[gazebo]: http://gazebosim.org/
[leap_motion]: https://www.leapmotion.com/
[kadenze_moc]: https://www.kadenze.com/courses/machine-learning-for-musicians-and-artists/info
[JFS]: https://www.java-forum-stuttgart.de/de/Home.html
[JFS_roboarmcontroller]: https://www.java-forum-stuttgart.de/de/Vortr%E4ge+von+14.30+-+15.15+Uhr.html#D5
[roboarmcontroller_demo]: http://www.youtube.com/watch?v=JWlY6wcq-mY&t=29m10s
[eclipsecon_roboarmcontroller_video]: http://www.youtube.com/watch?v=JWlY6wcq-mY
[eclipsecon_roboarmcontroller_slides]: https://www.eclipsecon.org/europe2019/sessions/prototyping-robot-arm-controller-getting-hands-dirty-learn-new-technologies
