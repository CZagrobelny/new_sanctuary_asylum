# New Sanctuary Coalition

## Getting setup

### System Dependencies

* ruby v 2.3.3
* ruby c headers
* postgres v 9.6
* postgres c headers

To install on debian/ubuntu:

``` shell
sudo apt install ruby libpq-dev ruby-dev
```

### Ruby Dependencies

```
gem install bundler
bundle install
```


### Database setup

Run your favorite database server in your favorite way. To run postgres in a docker container, you can do the following:


```shell
docker pull postgres:9.6
docker run --name new_sanctuary -p "127.0.0.1:5432:5432" -e POSTGRES_PASSWORD=password -d postgres:9.6
```

To run initial migrations and seed the DB:

```
rake db:setup
```

## Environment Variables

**Placeholder (none at this time)**


## Running the test suite

```
rspec
```

CircleCI is set up for the app, I think you might have access to the builds, since it's public, but let me know if you don't see it.


## Running the App Locally

``` shell
rails server
```

## What are we building?

Software to support the core work of the New Sanctuary Coalition: helping our friends fill out applications for asylum and accompanying them to their hearings and check-ins.

### User Roles

#### Admin Role (has access to everything)
- Can view friends, create new friend records, edit friend records, and delete friend records
- Can view users, invite users, edit users, and delete users
- Can create activities for a friend (and can edit them)
- Can create, edit, and remove asylum application drafts for a friend
- Can share friend records with specific users (In the 'Asylum' tab when editing a friend, the 'Volunteers with Access' field)
- Can view detailed information about friend activities in the current month and last month

Login as an Admin with:
* username: admin@example.com
* password: password

#### Volunteer Role (has limited access)
- Can receive an invitation (emailed) and follow the link to create a volunteer account
- Can view limited details about friend activities (ie. accompaniements) this week and next week
- Can RSVP to attend a friend activity (ie. accompaniement) and can edit their RSVP
- Can view friend records that have been shared with them
- Can add other users to friend records that have been shared with them
- Can create, edit, and remove asylum application drafts

Login as an Volunteeer with:
* username: volunteer@example.com
* password: password

## How are we building it?

### Gems & Libraries!
Aiming to keep our list of dependencies short, maintainable, and reliable!

Here are the big ones:
- Bootstrap: http://getbootstrap.com
- Chosen: https://github.com/harvesthq/chosen (nice, searchable dropdowns)
- Will Paginate: https://github.com/mislav/will_paginate

If there is anything else you think is essential, let's talk about it.

### Test Coverage!
Aiming to cover the functionality we build with:
- model tests
- feature tests to cover the main pathways through the app

### Hosting
**Info coming soon.**

## Contributing
1. Select a story from the Trello board: https://trello.com/b/nSt2qssz/new-sanctuary
2. Create a feature branch off master.
3. Complete feature with tests!
4. Check CircleCI to make sure tests are passing.
5. Make a pull request and tag me, CZagrobelny, to review.
6. Merge into master upon approval of the pull request.
