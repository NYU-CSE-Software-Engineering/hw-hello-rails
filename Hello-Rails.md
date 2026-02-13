# CHIP 4.8: Hello, Rails!

[View this assignment on GitHub](https://github.com/saasbook/hw-hello-rails)

## Introduction

In previous assignments, you created and deployed a simple Wordguesser game using the Ruby-based Sinatra framework, and in the subsequent assignment, you explored the differences between the Rails and Sinatra versions of that same app.

In this assignment you will create your first Rails app from scratch: a simple app called RottenPotatoes (inspired by the real web site RottenTomatoes) for cataloging movies. RottenPotatoes lets users interactively (via a Web browser) create database entries for new movies, view or modify the content of movie records (movie title, rating, description, and so on), and delete movie records.  We provide some starter code you can copy and paste into specific files, but you will do most of the work.  When the app is running, you'll deploy it on the public cloud.

In later assignments, you'll add features to the app, such as the ability to filter the list of movies, the ability to associate reviews with movies, and per-user login so each user can maintain their own ratings of movies.

## Learning Goals

After this assignment, you should know how to:

1. Create a new Rails app from scratch, including making necessary adjustments to the `Gemfile` (specifying which libraries the app relies on) and immediately placing the app under version control so you can keep track of changes

2. Set up a database to store the Rails models, by writing and executing an initial migration describing the database's schema

3. Create a basic set of controller actions and views to support the CRUD actions (create, read, update, delete) on a resource in a Rails app, and specify HTTP routes that map to the controller actions

4. Run and interact with the app in your development environment, including using the debugger to interactively track down bugs and inspect application state, such as the parameters supplied to a controller action

5. Deploy the app to the public cloud, in this case using Heroku's Platform-as-a-Service (PaaS) facility

## Team Communication Requirement
 For CHIPS 4.8, 5.3, and 10.5, team communication will be mandatory and team feedback will be a component of each individual's grade. Your team will be required to meet at least once a week for the remainder of the term. Once your team has completed CHIPS 3.7, schedule a meeting that every member of your team can attend ASAP.

 **During your first team meeting**  Berkeley students: see the course website for additional requirements/deliverables that may apply to you.

## Pair-Programming Option

Starting with CHIPS 4.8, you will be allowed to form pairs within your team while completing the CHIPS assignments. This pairing must follow the model of pair-programming detailed in this course (Driver and Observer roles, frequent role switching, etc.) and you will work on a shared branch rather than each member having an individual branch.

## GitHub Branch Work Requirement

Each member or pair is required to complete the project and push their version of the code onto their branch of the GitHub repo for credit on CHIPS 4.8 and CHIPS 5.3 next week.

## Grading of Team Feedback
We will be releasing a team feedback and self-evaluation form for CHIPS 4.3 by next week. We will use the data collected in these forms to assess team participation for CHIPS 4.3 and reach out to members who seem to not have been actively communicating with their team during this assignment.

Your team's feedback will play a role in your grading and will be based on the score your teammates provide you in the evaluation. However, if you are actively engaged with your team by attending meetings or communicating and catching up with your team afterward if you can't catch a meeting, you should have no reason to worry about your grade.
