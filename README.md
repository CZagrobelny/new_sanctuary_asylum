# New Sanctuary Coalition

## What are we building?

The New Sanctuary Coalition is a network of congregations, organizations, and individuals standing publicly in solidarity with families and communities resisting detention and deportation. This internal database software facilitates NSC's core programs and allows them to operate at increasing scale.

NSC's programs include:
- Accompaniment Program: pairs undocumented people with a group of trained volunteers to accompany them to their immigration hearings and check-ins with ICE.
- Pro-se Clinic: a weekly clinic where undocumented people work with trained volunteers and lawyers to prepare documents (asylum applications, juvenile visas, etc.) to fight their immigration case.
- Anti-Detention Program: works with detained immigrants across the US and their families to fight for their release.

More information:  http://www.newsanctuarynyc.org/

## Getting setup

### System Dependencies

* ruby (see Gemfile for version)
* postgres

### Environment Variables

```
FROM_ADDRESS='test@example.com'
```

For local development, create a `.env` file in the root directory of the application and put the environment variable in there. There is a `.env.example` file.

### Using Docker to Run the Application 

Docker is a way for you to run this application on your machine without changing any of your local settings or installing anything new (besides Docker itself).

More instructions [here](DOCKER_README.md).

### Ruby Dependencies

```
gem install bundler
bundle install
```


### Database installation

This app uses a Postgresql database.  Instructions diverge based on your operating system.

#### 1. Mac OS
Install Postgres.app:  https://postgresapp.com

#### 2. All non-Mac OS
I recommend running Postgres in a docker container. To run Postgres on docker, you can do the following:

```shell
docker pull postgres:9.6
docker run --name new_sanctuary -p "127.0.0.1:5432:5432" -e POSTGRES_PASSWORD=password -d postgres:9.6
```

NOTE: If you are using `psql` instead of Postgres.app, create your user this way:

```
$ createuser postgres --createdb
$ psql
psql (10.2)
Type "help" for help.

yourname=# ALTER USER postgres WITH PASSWORD 'password';
```

### Database setup

To run initial migrations and seed the DB:

```
cp config/database.yml.sample config/database.yml
rake db:setup
```

To switch from using docker back to using the rails server locally, run:
```
cp config/database.yml.sample config/database.yml
```

## Running the test suite

```
rspec
```

CircleCI is set up for the app, and will run the full test suite when you push to github.  There are still some flappy specs, unfortunately :/ ...so, if the specs pass locally, but not on CircleCI, feel free to leave a note when you create your PR.


## Running the App Locally

```shell
rails server
```

## User Roles

#### Regional Admin (has access to all communities within their regions)
- Can do everything that a Community Admin can do for the communities in their regions
- Can view, create, edit communities in their regions

Login as a Regional Admin with:
* username: ny_regional_admin@example.com
* password: Password1234


#### Community Admin Role (has access to everything scoped to their Community)
- Can view friends, create new friend records, edit friend records, and delete friend records
- Can view users, invite users, edit users, and delete users
- Can create activities for a friend (and can edit them)
- Can create, edit, and remove asylum application drafts for a friend
- Can share friend records with specific users (In the 'Asylum' tab when editing a friend, the 'Volunteers with Access' field)
- Can view, create, edit sanctuaries
- Can view create, edit lawyers

IF the Community is 'primary' (ie. primary = true), additionally:
- Can view create, edit locations
- Can view create, edit judges
- Can generate reports
- Can create, edit, delete NSC events (ie. trainings and workshops) and can take attendance of volunteers and friends attending the event
- Can view an index of upcoming and past Activities and Accompaniments

Login as an Admin of a Primary Community with:
* username: nyc_admin@example.com
* password: Password1234

Login as an Admin of a Non-Primary Community with:
* username: li_admin@example.com
* password: Password1234

#### Community Volunteer Role (has limited access to their community)
- Can receive an invitation (emailed) and follow the link to create a volunteer account
- Can view friend records that have been shared with them
- Can add other users to friend records that have been shared with them
- Can create, edit, and remove asylum application drafts

IF the Community is 'primary' (ie. primary = true), additionally:
- Can view limited details about friend activities (ie. accompaniments) this week and next week
- Can RSVP to attend a friend activity (ie. accompaniment) and can edit their RSVP

Login as an Volunteeer for a Primary Community with:
* username: nyc_volunteer@example.com
* password: Password1234

Login as an Volunteeer for a Non-Primary Community with:
* username: li_volunteer@example.com
* password: Password1234

#### Community Accompaniment Leader Role (only applicable to Primary communities)
- Can do everything a volunteer can do
- Can view contact information about friends and volunteers involved in accompaniments
- Can create report for accompaniments they attend

Login as an Accompaniment Leader with:
* username: nyc_accompaniment_leader@example.com
* password: Password1234

## How are we building it?

### Gems & Libraries!
Aiming to keep our list of dependencies short, maintainable, and reliable!

Here are the big ones:
- Bootstrap: http://getbootstrap.com
- Chosen: https://github.com/harvesthq/chosen (nice, searchable dropdowns)
- Will Paginate: https://github.com/mislav/will_paginate
- Textacular: https://github.com/textacular/textacular

### Test Coverage!
Aiming to cover the functionality we build with:
- model tests
- feature tests to cover the main pathways through the app
- controller specs (ONLY for authorization)

### Staging App
We have a staging app here with seed data:  https://frozen-sea-20640.herokuapp.com
The data is refeshed occassionally, but activities/accompaniments are likely to be out of date.

## Contributing
1. Add a comment on your chosen Github issue to let other contributors know that you have 'claimed' it.
2. Create a feature branch off master.
3. Complete feature with tests!
4. Check CircleCI to make sure tests are passing.
5. Make a pull request and tag CZagrobelny to review.
6. CZagrobelny will leave feedback and merge into master upon approval of the pull request.

## Code of Conduct
[Here](CODE_OF_CONDUCT.md)

## Questions?
- Questions about a PR, tag CZagrobelny in a comment on the PR
- Other questions, email newsanctuary.tech@gmail.com

## Contributors
We have an amazing group of contributors and organizations working to build out the software!
- Individual Contributors: https://github.com/CZagrobelny/new_sanctuary_asylum/graphs/contributors
- Ruby for Good: https://rubyforgood.org
- Progressive Hacknight:  http://www.progressivehacknight.org
