## Change the database for production

In the Sinatra Wordguesser assignment, you already learned how to deploy a Sinatra app to Heroku. Deploying a Rails app is very similar, but a few extra steps are required since most Rails apps use databases.

All apps on Heroku use the PostgreSQL database.  For Ruby/Rails apps to do so, they must include the `pg` gem.  However, we don't want to use this gem while developing, since we're using SQLite for that. Gemfiles let you specify that certain gems should only be used in certain environments.  Rails apps examine the environment variable `RAILS_ENV` to determine which environment they're running in, to make decisions such as which database to use (`config/database.yml`) and which gems to use. Heroku sets this variable to `production` at deploy time; running tests sets it to `test`; while you're running your app interactively, it's set to `development`.

To specify production-specific gems, you must make **two** edits to your Gemfile.  First, add this:

```
group :production do
  gem 'pg', '1.6.0.rc1' # for Heroku deployment
end
```

(If there is already a `group :production` in your Gemfile, just add those lines to it.).

Second, find the line that specifies the `sqlite3` gem, and tell the Gemfile that that gem should **not** be used in production, by moving that line into its own group like so:

```
group :development, :test do
  gem "sqlite3", ">= 1.4"
end
```

This second step is necessary because Heroku is set up in such a way that the `sqlite3` gem simply won't work, so we have to make sure it is _only_ loaded in development and test environments but _not_ production.

As always when you modify your Gemfile, re-run `bundle install` and commit the modified `Gemfile` and `Gemfile.lock`. If it errors out, try
`bundle config set without 'production'`. Note that bundler will remember the `without 'production'` option (check `.bundle/config`) so that you only need to run `bundle install` next time.

Also note that when you run Bundler, it will still compute dependencies and versions for gems in the `production` group, but it won't install them.  Heroku will use `Gemfile.lock` to install the matching versions of the gems when you deploy.

**Don't we have to modify `config/database.yml` as well?**
You'd think so, but the way Heroku works, it actually _ignores_ `database.yml` and forces Rails apps to use Postgres.  So modifying the `production:` section of `database.yml` won't have any effect on Heroku.


## Pull Request Instructions

Now that we've got all our app up and running locally and prepped the production environment database, it's time to get these changes on the main branch of your GitHub repo through a Pull Request (PR). First, make sure you have committed all of your changes so far to your branch, then push that branch to the GitHub remote as you did before.

You can create a PR directly through the GitHub site by clicking the "X branches" button near the top of the repo page.

![](.guides/img/branches.png)

From here, find your branch and click `New pull request`.

![](.guides/img/open_pr.png)

Now make sure that the base branch is `main` and that the compare branch is your own. Then add a title and a description of the changes you've made as well as any other info that you'd like your team to know about your PR. Once you create the PR, let your teammates know so that they can check out the changes and approve the PR.

![](.guides/img/create_pr.png)

Protocols vary from team to team, but in general, it is good practice to have at least 1 or 2 teammates review your changes to ensure that no bugs creep through to the merge. Once the reviews are in, all comments addressed, and any potential merge conflicts are resolved, you can merge in your changes!

Although every team member should make a pull request, only one team member needs to merge their code into the `main` branch. Once they have done that, in your Codio terminal, checkout the `main` branch and pull in these new changes using `git checkout main && git pull origin main`.

## Deploy to Heroku

Log in to your Heroku account by typing the command: `heroku login -i` in the terminal. Provide your berkeley.edu (or approved alternative) email but when it asks for a password, instead you must find your **API Key** from the bottom of the [Account Settings page on Heroku](https://dashboard.heroku.com/account). Copy and paste this value in for the password and you should be able to log in and bypass the 2-Factor-Authentication that is normally impossible to do in the Codio terminal.

Now let's add Heroku to your git repo as a remote named `heroku` using the following commands where `<xx>` is replaced by your team number (ex: `fa23-08`).

```
heroku apps:favorites:add -a fa23-<xx>
heroku git:remote -a fa23-<xx>
```

One of the challenges of modern software engineering is keeping up with changing versions.

A "stack" is a term that describes the operating system and default software that you application is running on. Heroku has a [large set of stacks][stacks] you can select from.

OK, the moment of truth has arrived. Make sure no one else on your team is in the middle of completing this step, then run `git push --force heroku main` to force-push the current head of your main branch to Heroku.  Although we normally prefer to avoid force-pushes where possible, this may be necessary in case your team's Heroku app still contains repository history from CHIPS 3.7.

Heroku will try to install all the Gems in your gemfile and fire up your app! Once the deploy has succeeded, you can find the link to your app near the bottom of the output in the terminal or in the Heroku dashboard for your app which can be found [here](https://dashboard.heroku.com/teams/esaas/apps). You should now be able to view your app!
Right?

[stacks]: https://devcenter.heroku.com/articles/stack

Almost. If you try this, you'll see a Heroku error. (If not, another team member may have performed the following steps on your deployment database already. If you want to follow along with the following steps, you can first reset your database state by heading to your Heroku app, clicking on the Heroku Postgres addon, and clicking "Reset Database" in the Settings tab).

<details>
<summary>
<b>Self-check question:</b> Use the command <code>heroku logs</code> to see the last several lines of error log messages from Heroku.  What caused the error?
</summary>
<blockquote>
As the error message <code>relation "movies" does not exist</code> tells us, there is no <code>movies</code> table on Heroku -- in fact there isn't even a  database.
</blockquote>
</details>

(It's worth making sure you understand the self-check question before charging on to the fix!)

## Fix Heroku deployment

Creating the database locally required 2 steps: first we ran the initial migration to create the `movies` table (schema), then we seeded the database with some initial data.  We must do these 2 steps on Heroku as well, by preceding each with `heroku run`, which just runs the corresponding command in a shell on Heroku:

```
heroku run rails db:migrate
```
Now go verify that you can visit your app, but no movies are listed...
```
heroku run rails db:seed
```
...and now your app should work on Heroku just as it does locally,
with the seed data.

Note that in the future you should put these commands in a `Procfile` to avoid manually typing them. These documentations may be helpful: [Release Phase](https://devcenter.heroku.com/articles/release-phase) and [Procfile] (https://devcenter.heroku.com/articles/procfile#procfile-naming-and-location). For a more direct answer, check out [this post](https://medium.com/devkedi/run-migrations-when-deploying-to-heroku-4a11a5e9b055)

Voila -- you have created and deployed your first Rails app!


<details>
<summary>
What are the two steps you must take to have your app use a particular Ruby gem?
</summary>
<blockquote>
You must add a line to your <code>Gemfile</code> to add a gem and re-run <code>bundle install</code>.
</blockquote>
</details>

<details>
<summary>
The <i>first</i> time you deploy a particular app on Heroku, what steps do you need to take (assuming you have adjusted your <code>Gemfile</code> correctly as described above)?
</summary>
<blockquote>
Create the app container on Heroku; push the app to Heroku; run the initial migration(s) to create the database; and if appropriate, seed the database with initial data.
</blockquote>
</details>


<details>
<summary>
When you make changes to your app code, including adding new migrations, what must you do to <i>update</i> the existing Heroku app? (HINT: try making a simple change to the app, like changing something in a view, and see if you can deduce the sequence of steps.)
</summary>
<blockquote>
Commit changes to Git, then <code>git push heroku master</code> to redeploy. If you created new migrations, you also need to <code>heroku run rails db:migrate</code> to apply them on the Heroku side.
</blockquote>
</details>
