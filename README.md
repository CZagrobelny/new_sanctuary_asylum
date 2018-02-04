# New Sanctuary Coalition

## What are we building?

Software to support the core work of the New Sanctuary Coalition: helping our friends (undocumented immigrants) fill out applications for asylum and accompanying them to their hearings and check-ins.

## Getting setup

### System Dependencies

* ruby (see Gemfile for version)
* postgres

### Ruby Dependencies

```
gem install bundler
bundle install
```


### Database setup

Run your favorite database server in your favorite way. 

Postgres.app is the best option on Mac:  https://postgresapp.com

If you are not working on a Mac, I recommend running Postgres in a docker container. To run Postgres on docker, you can do the following:

```shell
docker pull postgres:9.6
docker run --name new_sanctuary -p "127.0.0.1:5432:5432" -e POSTGRES_PASSWORD=password -d postgres:9.6
```

To run initial migrations and seed the DB:

```
cp config/database.yml.sample config/database.yml
rake db:setup
```

### Environment Variables

FROM_ADDRESS='test@example.com'

For local development, create a '.env' file in the root directory of the application and put the environment variable in there.


## Running the test suite

```
rspec
```

CircleCI is set up for the app, and will run the full test suite when you push to github.  There are still some flappy specs, unfortunately :/ ...so, if the specs pass locally, but not on CircleCI, feel free to leave a note when you create your PR. 


## Running the App Locally

``` shell
rails server
```

## User Roles

#### Admin Role (has access to everything)
- Can view friends, create new friend records, edit friend records, and delete friend records
- Can view users, invite users, edit users, and delete users
- Can create activities for a friend (and can edit them)
- Can create, edit, and remove asylum application drafts for a friend
- Can share friend records with specific users (In the 'Asylum' tab when editing a friend, the 'Volunteers with Access' field)
- Can view detailed information about friend activities in the current month and last month
- Can manage lawyer records, location records, and judge records
- Can create, edit, delete NSC events (ie. trainings and workshops) and can take attendance of volunteers and friends attending the event 

Login as an Admin with:
* username: admin@example.com
* password: Password1234

#### Volunteer Role (has limited access)
- Can receive an invitation (emailed) and follow the link to create a volunteer account
- Can view limited details about friend activities (ie. accompaniments) this week and next week
- Can RSVP to attend a friend activity (ie. accompaniment) and can edit their RSVP
- Can view friend records that have been shared with them
- Can add other users to friend records that have been shared with them
- Can create, edit, and remove asylum application drafts

Login as an Volunteeer with:
* username: volunteer@example.com
* password: Password1234

#### Accompaniment Leader Role
- Can do everything a volunteer can do
- Can view contact information about friends and volunteers involved in accompaniments
- Can create report for accompaniments they attend

Login as an Volunteeer with:
* username: accompaniment_leader@example.com
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

## Contributing
1. Contact Christine at newsanctuary.tech@gmail.com to request access to the Trello board (backlog) and github repo.
2. Select a story from the Trello board: https://trello.com/b/nSt2qssz/new-sanctuary
3. Create a feature branch off master.
4. Complete feature with tests!
5. Check CircleCI to make sure tests are passing.
6. Make a pull request and tag CZagrobelny to review.
7. CZagrobelny will leave feedback and merge into master upon approval of the pull request.

## Questions?
- Questions about a Trello card, leave a comment tagging '@Christine Zagrobelny'
- Questions about a PR, tag CZagrobelny in a comment on the PR
- Other questions, email newsanctuary.tech@gmail.com
