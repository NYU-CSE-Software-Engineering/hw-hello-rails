## Verify you have correct versions of Ruby, Rails, and Heroku CLI installed

(If you're using Codio, follow steps 3 and 4 only.)

1. Run `ruby -v` to check your Ruby version is >= 3.3.
2. Run `rails -v` to check your Rails version is 7.1.5. The assignment has not been tested with other versions, and there are files that will almost certainly cause errors with Rails >=8.*.*
3. Run `bundle -v` to **check your Bundler version is ~> 2.6.9**. 
4. If you now have more than one version of bundler installed, run `gem uninstall bundler`. A prompt will ask which version you'd like to uninstall. Enter the number associated with bundler-2.1.4 (likely `2`). Another prompt will appear asking to remove the bundler executable, enter `Y`.
5. Run `heroku -v` to verify the `heroku` [command line tool](https://devcenter.heroku.com/articles/heroku-cli) has been installed in the development environment.

## Clone the git repository that has been created for your team

First, run a `git clone` command. The repository `cs169/fa23-chips-4.8-xx.git` has been created for your team already. You should replace `-xx` with your team number (one or two digits). The final argument of this git clone command (`rottenpotatoes`) is the name of the folder that Git will create to house the repository contents. This command will require that you be authenticated with Git, as was required in CHIPS 3.7.

```sh
git clone git@github.com:cs169/fa23-chips-4.8-xx.git rottenpotatoes
cd rottenpotatoes
```

Then, check out a branch for you or your pair. If you're completing CHIPS 4.8 individually, replace `<YOUR_BRANCH_NAME>` with your GitHub username (ex: `ethangnibus`). Pairs replace `<YOUR_BRANCH_NAME>` with the github usernames of the members of the pair separated by an underscore (ex: `ethangnibus_simonjov`). 

```sh
git checkout -b <YOUR_BRANCH_NAME>
```

Your Git repository came with a README. If another team member has already started CHIPS 4.8, they may have pushed to the `main` branch of your shared repository already. Either way, for CHIPS 4.8, you should remove every file in the repository so you can practice creating a Rails app for yourself. Keep in mind that the following command should be run in your Codio box **inside** the `rottenpotatoes` directory that was created:

```sh
rm -rf ./*
```

This command will remove most files in the directory, but will spare hidden files (any file whose name starts with a `.` character). That way, your `.git` folder is safe, and your repository will still function.

## Create a new Rails app

You may find the Rails [online documentation](https://api.rubyonrails.org/v4) useful during this assignment.

Now that you have Ruby and Rails installed and your Git repository created, create a new, empty Rails app with the command:

```sh
rails new . --skip-test-unit --skip-turbolinks --skip-spring
```

The options tell Rails to omit three aspects of the new app:

* Rather than Ruby's `Test::Unit` framework, in a future assignment we will instead create tests using the RSpec framework.

* Turbolinks is a piece of trickery that uses AJAX behind-the-scenes to speed up page loads in your app.  However, it causes so many problems with JavaScript event bindings and scoping that we strongly recommend against using it.  A well tuned Rails app should not benefit much from the type of speedup Turbolinks provides.

* Spring is a gem that keeps your application "preloaded" making it faster to restart once stopped.  However, this sometimes causes unexpected effects when you make changes to your app, stop and restart, and the changes don't seem to take effect.  On modern hardware, the time saved by Spring is minimal, so we recommend against using it.

If you're interested, `rails new --help` shows more options available when creating a new app.


If all goes well, you'll see several messages about files being created, ending with run `bundle install`, which may take a couple of minutes to complete.  From now on, unless we say otherwise, **all file names and commands** will be relative to the app root.  Before going further, spend a few minutes examining the contents of the new app directory `rottenpotatoes` to remind yourself with some of the directories common to all Rails apps.

What about that message run `bundle install`?
Recall that Ruby libraries are packaged as "gems", and the tool `bundler` (itself a gem) tracks which versions of which libraries a particular app depends on. Open the file called `Gemfile` --it might surprise you that there are  already gem names in this file even though you haven't written any app code, but that's because Rails itself is a gem and also depends on several other gems, so the Rails app creation process creates a  default `Gemfile` for you.  For example,  you can see that `sqlite3` is listed, because the default Rails development environment expects to use the SQLite3 database.

OK, now ensure you're changed into the directory of the app you just created (`cd rottenpotatoes`) to continue...

## Specify Ruby version

It is a good practice to specify the Ruby version you are using in the `Gemfile`. Run `ruby -v` in the terminal to check the version you are using. In the `Gemfile`, add `ruby '<version>'` below `source 'https://rubygems.org'`. For example, on Codio you will see `ruby '3.3.8'`.

## Check your work

To make sure everything works, run the app locally.  (It doesn't do anything yet, but we can verify that it is running and reachable!)

Follow the instructions below to run and preview a Rails app locally -- the steps are a bit different depending on whether you're using Codio. When you visit the app's home page, you should see the generic Ruby on Rails landing page, which is actually being served by your app.  Later we will define our own routes so that the "top level" page does not default to this banner.

## If developing in Codio

1. You will need to allow external hosts to access the application:
    a. Open `config/environments/development.rb`
    b. Add `config.hosts.clear` anywhere inside the application's configurations.
2. Start the app in a terminal:  `rails server -b 0.0.0.0`
3. At the top of the Codio page, find the dropdown next to the button that is either labeled "Project Index (static)" or "Box URL".
4. From the dropdown, select "Box URL" and "New Browser Tab".
5. Then click on the "Box URL" button (not the dropdown). A new tab should open up with a webpage in which your code has come to life!

## If developing Locally

If you're developing locally, the steps would instead be these:

1. Start the app in a terminal: `rails server`  (omit `-b 0.0.0.0`)
2. Open a regular browser window to `localhost:3000/` to visit the app's home page (note the `:3000` rather than `-3000`)

## Why the difference?

TL;DR: To tunnel HTTP traffic to port _port_ on Codio subdomain _subdomain_`.codio.io`, point a browser at `https://`_subdomain_`-`_port_`.codio.io`.

For the curious: When developing in Codio, `localhost` doesn't work as you'd expect, because it refers to the virtual machine hosted at Codio in which you're developing.  But Codio arranges to do [HTTP tunnelling](https://en.wikipedia.org/wiki/HTTP_tunnel) for you--if you form the URL using _subdomain_`-`portnumber`.codio.io`, traffic will be tunneled to port `portnumber` of the virtual machine running at `subdomain`.

Git Walkthrough
----------------

Now it's time to push your changes to your team's shared repository on GitHub. First, create a commit with all of your changes, including the new Rails app you built. If another team member has already pushed to the `main` branch, you may find that this commit doesn't contain many changes. Note that when you created the app, Rails added a `.gitignore` file to prevent git from tracking unnecessary files.

```sh
git add --all .
git commit -m "Initial commit from <your name>"
```

After the commit is created, you can push your branch to the remote.

```sh
git push -u origin <YOUR_BRANCH_NAME>
```

As you continue to make changes to your repo, be sure to check to use `git branch` to make sure you are on your own branch before committing locally. Then, to push your changes to your remote branch simply run `git push origin`.
