---
layout: post
title:  "RoboArm Controller, part I: Intro and architecture. Status: Draft"
date:   2020-04-28T09:25:52+01:00
author: Enrique Llerena Dominguez
categories: learning-machine-learning machine-learning 
tags: deeplearning4j tensorflow java pyhton gazebo architecture roboarm-controller
cover:  "/assets/posts/roboarmcontroller-intro/roboarmcontroller-cover.jpg"
cover_credits: Photo by David Fanuel on Unsplash
---

# Learning Machine Learning Series

This is the first post of a series where I want to describe my journey learning machine learning, a topic I am 
passionate about.

# RoboArm Controller, part I: Intro and architecture

# TL;DR

- The RoboArm Controller enables a user to control a simulated robotic arm with the position of their hands.
- Check out the code at the  [Github repo: ellerenad/RoboArmController][roboarmcontroller_repo] 
- [Demo][roboarmcontroller_demo]
- The following technologies were used: Java, Python, C++, Tensorflow, Deeplearning4j, Spring, JUnit, Gazebo, plus other tools.
- The RoboArm Controller has 3 main components: a simulated robotic arm, a data transformation application, and the hands' sensor.
- The machine learning part is on the data transformation: classify the position of the hands to get a movement instruction.
- The RoboArm Controller covers the machine learning cycle: Gather the data, prepare the data, choose a model, train the model,
 tune the hyperparameters, test the model, export the model, import the model into a "production" system, and use it to make predictions.
- The project was presented at the [Java Forum Stuttgart 2019][JFS_roboarmcontroller] and the EclipseCon Europe 2019 ([video][eclipsecon_roboarmcontroller_video]/[slides][eclipsecon_roboarmcontroller_slides])
- The RoboArm Controller is a hobby project I developed to practice different technologies in a ludic way.


## Introduction

The RoboArm Controller allows controlling a simulated robotic arm with the position of the hands of a person.
It is a classification problem: There is a bunch of coordinates, representing the position of a hand, and the goal is to transform them into an instruction, so that:
`Instruction = map(classify(hand))`, where an example of an `Instruction` is `Move the servo number 1 applying a positive change`.

<figure>
  <img src="/assets/posts/roboarmcontroller-intro/hands-position-to-instruction.png" alt="Mapping the position of a hand to an instruction"/>
  <figcaption class="image-description">Mapping the position of a hand to an instruction: The left hand (green arrow) indicates which servo to move,
   whereas the right hand (yellow arrow) indicates a positive or negative delta</figcaption>
</figure>

This fits the learning goals (mentioned on the afterword) because:
1. The RoboArm Controller is a data stream, where the data originates on the sensor, is transformed, and eventually it "moves"
the simulator. 
1. The RoboArm Controller can be controlled with a machine learning part because the transformation of the data is a classification problem, 
where the positions of the hand have a label, which itself can be mapped to an instruction. 
1. The RoboArm Controller enables the practice of the machine learning framework because it is an end to end machine learning system,
 executing the following steps: Gather the data, prepare the data, choose a model, train the model, tune the hyperparameters,
 test the model, export the model, import the model into a "production" system, and use it to make predictions. 


## Architecture

This is a data stream: the data is originated on the hands' sensor, then it is read by the data transformation
application, where it is transformed from a set of positions to either a data set or to a movement instruction, and on the latter case sent
to the robotic arm, where the instruction is interpreted and applied to the simulation.

It has 3 main components:
1. A hands sensor.
1. A data transformer application.
1. A simulated robotic arm.

Note: I don't consider the Machine Learning module as a component, from my perspective it is more a tool used by a component or even an implementation detail.
I show it here because it is a goal on the project: learn a machine learning framework.

<figure>
  <img src="/assets/posts/roboarmcontroller-intro/target-architecture.png" alt="Current architecture"/>
  <figcaption class="image-description">Current architecture of the RoboArm Controller.</figcaption>
</figure>

If you want to see more diagrams related to the architecture of this project, you can find them at the
 [Architecture folder of the GitHub repo][roboarmcontroller_repo_architecture]

## Brief Description of the components

This is just an overview of each of the main components used for the project. If these series get enough traction, I will
write a post describing each one of them

### Hands Sensor

This is the origin of the data, where the position of the hands is sensed.
Used the [Leap Motion][leap_motion] sensor. It has a framework to communicate with different languages, but the way I got to talk 
with it was through a WebSocket. It provides coordinates for a set of points related to the hands, e.g. the tips of the fingers,
the center of the hand, and so on.
- Technologies used: Leap Motion.
- Interfaces: Websocket.
- Input: The hands.
- Output: Position of different parts of the hands, sent to the data transformer application.

### The data transformer application

This is the place to find the main domain logic.
It is a Java/Spring Boot application, where the hands' position data is transformed into movement instructions for the simulated robotic arm.
It has an internal onion architecture, where I applied my knowledge of domain-driven design.
It has 2 different execution states:
1. Training mode: Generation of the data set + training of the machine learning model (when the used framework allows it, details below). 
It takes the positions read from the hands' sensor, process them, creates a data set, and tries to trigger the training for the machine learning 
model.
1. Control mode: Transformation of the hands' positions into movement instructions.
It takes the positions read from the hands' sensor, process them, and feeds this data to the machine learning framework for classification,
then interprets this data, transforms it to an instruction, and sends it to the robotic arm via TCP sockets.

Two machine learning frameworks are supported:
1. Tensorflow (v1).- This framework does not allow the training with java, hence the training needs to be done with a separate python 
script, it is provided in the form of a Jupyter notebook.
1. Deeplearning4j.- This framework provides support to train a model with java, so the model is generated.

The execution states and the used machine learning framework are controlled through Spring profiles. 

- Technologies used: Java + Spring, jUnit, maven, TensorFlow, deepelearning4j.
- Interfaces: WebSocket, TCP Socket.
- Input: Position of different parts of the hands.
- Output: Instructions for the robotic arm.


### Simulated robotic arm

It is a -rather simple- simulation of a robotic arm, done in [Gazebo][gazebo], with 3 degrees of freedom. It is controlled by a C++ plugin.
This plugin receives instructions from the exterior on a TCP port, with the format `<servoId delta>`, so the instruction `1 5` 
would move the `servoId: 1` `5` positive degrees.
- Technologies used: Gazebo, C++.
- Interfaces: TCP Socket.
- Input: Instructions from the data transformer application.
- Output: Visualization of the Robot Arm. It could also return the position of the servos.


## Conclusion

We saw an overview of the motivation behind the RoboArm controller project, the architecture it has, and a brief description of its components.
If this series gets traction, I will write more posts about it, the next would be the data transformer application, as it is the 
component I find the most interesting.
If you find this interesting, reach me on [twitter][twitter_handle]! 

If you want to see more about this, check the following links:


- [Github repo: ellerenad/RoboArmController][roboarmcontroller_repo]

- [Demo of the project][roboarmcontroller_demo]


## Afterword

Some time ago, after having done the MOOC ["Machine Learning for Musicians and Artists"][kadenze_moc] at kadenze, I was eager to apply my knowledge,
so I started to look for a project to get the hands dirty with. It was not an easy task, as a parent I don't have a lot of time for a side project, maybe just
a couple of hours per week.

I was looking for the following characteristics for a project:
- Make me feel passionate about it
- Be an end to end Machine Learning system
- Let me experiment with different technologies in a ludic way.

Learning goals:
- A Machine Learning Framework: Tensorflow, deeplearning4j
- Apache Kafka
- Gazebo
 
The idea came connecting the dots of previous stuff I had done and seen:
- A simulated robotic arm I made for my masters' thesis
- The [Leap Motion][leap_motion] controller, that I got to know at the above-mentioned MOC from Kadenze.

I have not yet integrated Apache Kafka, let's see what the future says :) 

### Evolution of the project

The strategy to achieve the goals were:
1. Do a Minimum Viable Product
1. Do Small iterations to create small pieces with clearly testable deltas
1. Tackle the riskiest things first

The strategy was to tackle the following challenges:

1. Get data from the sensor
1. Model the simulated robotic arm, control it and communicate it with the exterior
1. Transform sensor data into movements:  Process data and communicate both components

I made an initial prototype with partial failures where I learned some nice stuff, but I'll leave the evolution to another post.







[roboarmcontroller_repo]: https://github.com/ellerenad/RoboArmController
[roboarmcontroller_repo_architecture]: https://github.com/ellerenad/RoboArmController/tree/master/src/architecture
[gazebo]: http://gazebosim.org/
[leap_motion]: https://www.leapmotion.com/
[kadenze_moc]: https://www.kadenze.com/courses/machine-learning-for-musicians-and-artists/info
[JFS]: https://www.java-forum-stuttgart.de/de/Home.html
[JFS_roboarmcontroller]: https://www.java-forum-stuttgart.de/de/Vortr%E4ge+von+14.30+-+15.15+Uhr.html#D5
[roboarmcontroller_demo]: http://www.youtube.com/watch?v=JWlY6wcq-mY&t=29m10s
[eclipsecon_roboarmcontroller_video]: http://www.youtube.com/watch?v=JWlY6wcq-mY
[eclipsecon_roboarmcontroller_slides]: https://www.eclipsecon.org/europe2019/sessions/prototyping-robot-arm-controller-getting-hands-dirty-learn-new-technologies
[twitter_handle]: https://www.twitter.com/ellerenad
