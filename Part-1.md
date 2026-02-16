## Set Up / Getting Started

1. We will use the provided [`Dockerfile`](Dockerfile) to build and run your development Docker container. However,
we do want to work in a "clean" directory, since our `rails` initialization command will make a new `git` project for us.
So, create a directory that will contain your Rails app/project and navigate into that new directory (e.g., 
`cd rottenpotatoes`).

2. Copy the Dockerfile from this repo and place it in the newly created directory, which will be the location of 
the project.

3. Now you can build and start your `Docker` container as we have done previously. By now, you should be familiar with
the commands to achieve this. Be sure that when you run the container:
- You enable the passthrough port to the host machine is configured to port 3000,
- The `app` directory is mounted from the host machine (enabling editing of application files outside the
  container), and
- That the container opens an interactive shell terminal for you to run commands inside the container

4. Verify that the container has the correct versions of the necessary software:
- Run `ruby -v` to check your Ruby version is `>= 3.3`.
- Run `rails -v` to check your Rails version is `7.2.3` or higher. The assignment has not been tested with other versions, and there are files that will almost certainly cause errors with Rails `>=8.*.*`

## Create a new Rails app

You may find the Rails [online documentation](https://api.rubyonrails.org/v7.2/) useful during this assignment.

1. In the container's shell, create a new, empty Rails app with the command:

```bash
rails new rottenpotatoes --skip-test-unit --skip-turbolinks --skip-spring --skip-docker
```

The options tell Rails to omit several aspects of the new app:

* The name of the app will be `rottenpotatoes`, and it will reside in the directory it created having the same name.

* Rather than Ruby's `Test::Unit` framework, in a future assignment we will instead create tests using the RSpec 
framework.

* `Turbolinks` is a piece of trickery that uses AJAX behind-the-scenes to speed up page loads in your app. However, it 
causes so many problems with JavaScript event bindings and scoping that we strongly recommend against using it. A 
well-tuned Rails app should not benefit much from the type of speedup Turbolinks provides.

* `Spring` is a gem that keeps your application "preloaded" making it faster to restart once stopped. However, this 
sometimes causes unexpected effects when you make changes to your app, stop and restart, and the changes don't seem to 
take effect.  On modern hardware, the time saved by Spring is minimal, so we recommend against using it.

* Skip creating a `Dockerfile`, since it is only used for production convenience, and it would overwrite our copy. We
will still use the one we have provided.

If you're interested, `rails new --help` shows more options available when creating a new app.

If all goes well, you'll see several messages about files being created, ending with run `bundle install`, which may 
take a couple of minutes to complete. From now on, unless we say otherwise, **all file names and commands** will be 
relative to the app root. Note that we did not do the `bundle install` on the command line as we have done previously, 
the `rails new` command did it after the creation of a number of file and directories, and the creation of a Gemfile,
as well as doing the `git init` command too!

Before going further, spend a few minutes examining the contents of the new app directory `rottenpotatoes` to remind 
yourself with some of the directories common to all Rails apps.

What about that message run `bundle install`? Recall that Ruby libraries are packaged as "gems", and the tool 
`bundler` (itself a gem) tracks which versions of which libraries a particular app depends on. Open the file called 
`Gemfile` --it might surprise you that there are already gem names in this file even though you haven't written any 
app code, but that's because Rails itself is a gem and also depends on several other gems, so the Rails app creation 
process creates a  default `Gemfile` for you.  For example, you can see that `sqlite3` is listed, because the default 
Rails development environment expects to use the SQLite3 database.

## Check your work

To make sure everything works, run the app locally. (It doesn't do anything yet, but we can verify that it is 
running and reachable!)

Follow the instructions below to run and preview a Rails app locally. When you visit the app's home page, you should 
see the generic Ruby on Rails landing page, which is actually being served by your app. Later we will define our own 
routes so that the "top level" page does not default to this banner.

> [!TIP]
> If you previously exited the Docker shell, the container is no longer running. Thus, you'll need to start it again
> to complete the steps below, and you will need to run `bundle install` to get the container's software installed. Be
> sure you are in the `rottenpotatoes` directory while in the shell so that you can correctly run the `bundle install`
> command.

1. Start the app: `rails server -b 0.0.0.0`
2. Open a browser window on the host machine and go to `localhost:3000/` to visit the app's home page
(note the `:3000` rather than `-3000`)
3. Finally, note the output created by the server in the Docker container's shell. You should see an indication of the 
browser's request, and also (as part of the first request) some database schema migration tables being created.

## Incremental Development

As you complete this assignment, consider doing work in phases, where you create a git branch, work on the code, test
the code on the server with the browser, and then commit the code to the branch. Developers often take this approach to 
make a point where if further development goes badly, you can "rollback" to this point and start over, without starting
completely over again. Some developers will even merge this branch and then create a new branch and continue development.
Again, these approaches support incrementally developing your new features.

## Next
[Part 2 - Database in different environments](Part-2.md)
