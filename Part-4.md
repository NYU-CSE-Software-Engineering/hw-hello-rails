## Change the database for production

In the Sinatra Wordguesser assignment, you already learned how to deploy a Sinatra app to Heroku. Deploying a Rails 
app is very similar, but a few extra steps are required since most Rails apps use databases.

All apps on Heroku use the PostgreSQL database. For Ruby/Rails apps to do so, they must include the `pg` gem. However, 
we don't want to use this gem while developing, since we're using SQLite for that. Gemfiles let you specify that 
certain gems should only be used in certain environments.  Rails apps examine the environment variable `RAILS_ENV` 
to determine which environment they're running in, to make decisions such as which database to use 
(`config/database.yml`) and which gems to use. Heroku sets this variable to `production` at deploy time; running tests 
sets it to `test`; while you're running your app interactively, it's set to `development`.

To specify production-specific gems, you must make **two** edits to your `Gemfile`.  First, add this:

```rb
group :production do
  gem 'pg', '>=1.6.0' # for Heroku deployment
end
```

(If there is already a `group :production` in your `Gemfile`, just add those lines to it.).

Second, find the line that specifies the `sqlite3` gem, and tell the `Gemfile` that that gem should **not** be used 
in production, by moving that line into its own group like so:

```rb
group :development, :test do
  gem "sqlite3", ">= 1.4"
end
```

This second step is necessary because Heroku is set up in such a way that the `sqlite3` gem simply won't work, so we 
have to make sure it is _only_ loaded in development and test environments but _not_ production.

As always when you modify your `Gemfile`, re-run `bundle install` and commit the modified `Gemfile` and `Gemfile.lock`. 
If it errors out, try `bundle config set without 'production'`. Note that bundler will remember the 
`without 'production'` option (check `.bundle/config`) so that you only need to run `bundle install` next time.

Also note that when you run Bundler, it will still compute dependencies and versions for gems in the `production` 
group, but it won't install them. Heroku will use `Gemfile.lock` to install the matching versions of the gems when 
you deploy.

**Don't we have to modify `config/database.yml` as well?**
You'd think so, but the way Heroku works, it actually _ignores_ `database.yml` and forces Rails apps to use Postgres.
So modifying the `production:` section of `database.yml` won't have any effect on Heroku. But we will need to provision
a database once we deploy our app to Heroku.

## GitHub Repo Instructions
Now that we've got all our app up and running locally and prepped the production environment database, it's time to get
these changes on the `main` branch of your GitHub repo.  Make a new private repo on GitHub that is owned by you. Then,
set the new repo as the `origin` in your local repo by doing the following, replacing the username and reponame with
your selections (I used `depasqua/esaas-rotten-potatoes`).

```bash
git remote add origin git@github.com:username/reponame.git
```

Ensure that all of your changes and files are committed to your local branch, and then push it to the origin. The last 
term of the command below should be the name of the branch you are currently using in your local repo, and should also
be replicated on the origin (GitHub).

```bash
git push --set-upstream origin branchname
```

Once pushed, you can use the GitHub interface to create a pull request (PR), review it, and then merge it. Yes, this 
is a little odd with a one-person developer repo, but code reviews and PRs will be very important when you work on a 
team.

After merging in GitHub, go back to your local repo and check out the `main` branch and pull in your merged changes:
using `git checkout main && git pull origin main`.

> [!IMPORTANT]  
> Note that by now, we expect that you have done enough of the CHIPS to be able to easily deploy to Heroku. You can also
> use Render, if you choose. Both platforms ([Heroku] (https://devcenter.heroku.com/articles/heroku-cli) and 
> [Render](https://render.com/docs/cli)) offer command line interfaces (CLI) tools so that you can deploy your app 
> via command line rather than via their web applications.

## Deploy to Heroku

Use the same approach as we did in CHIP 3.7 to deploy your app to Heroku. You can use the CLI to create a new
application, which will create a repo on their service, and set the repo as a remote on your local machine. As a
reminder, we did this via: 

```bash
heroku create depasquale-rotten-potatoes
```

OK, the moment of truth has arrived. Ensure that your code changes have been added and committed to your branch. 
Then run `git push heroku main` to push the current head of your main branch to Heroku. 

Heroku will try to install all the Gems in your gemfile and fire up your app! Once the deploy has succeeded, you can 
find the link to your app near the bottom of the output in the terminal or in the Heroku dashboard for your app 
which can be found [here](https://dashboard.heroku.com/teams/esaas/apps). You should now be able to view your app...
right?!?

Almost. If you try this, you'll see a Heroku error.

If you use the `heroku logs` command, you will likely see a lot of output.  Scroll back and you may see references to 
`sqlite3`. Since we have deployed our app to Heroku, Heroku has assumed (correctly) that we want to be in the 
`production` environment. Looking back at our `config/database.yml` file, it likely says that in production we use
`sqlite3`.

This is rather easy to fix for Heroku deployment, and we don't even need to change the `.yml` file!  (Your mileage may
vary with other PaaS options like Render).

What we do need to do is provision a database for our use.  While we can do this in the Heroku web app dashboard, let's 
get more familiar with controlling Heroku via the command line. Let's enable a database by doing:

```bash
heroku addons:create heroku-postgresql
```

The database will start to be created and attached to our deployed app (provisioned). Note that Heroku will give the 
database we provision a unique name. We can then use the name to check the status of the provisioning, since it takes
a minute to two. You can also check the status via the Heroku dashboard.

```bash
heroku addons:info postgresql-shallow-68220
```

If you check the heroku logs (`heroku logs` on the command line), you should see the provisioned database and the web 
application restarting.  Once that has occurred, use a web browser to check the application again! Did it work?!?

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

Creating the database locally required 2 steps: first we ran the initial migration to create the `movies` table 
(schema), then we seeded the database with some initial data. We must do these 2 steps on Heroku as well, by preceding 
each with `heroku run`, which just runs the corresponding command in a shell on Heroku:

```bash
heroku run rails db:migrate
```
Now go verify that you can visit your app, but no movies are listed...
```
heroku run rails db:seed
```
...and now your app should work on Heroku just as it does locally,
with the seed data.

Note that in the future you should put these commands in a `Procfile` to avoid manually typing them. These 
documentations may be helpful: [Release Phase](https://devcenter.heroku.com/articles/release-phase) and 
[Procfile] (https://devcenter.heroku.com/articles/procfile#procfile-naming-and-location).

Voilà -- you have created and deployed your first Rails app!

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

## Next
[Part 5 - Submitting your work](Part-5.md)