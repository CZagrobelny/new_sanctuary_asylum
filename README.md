# New Sanctuary Coalition

## Getting setup

#### Database setup
```
rake db:setup
rake populate_countries
rake populate_languages
```

#### Gems
```
bundle install
```

## Environment Variables

**Placeholder (none at this time)**


## Running the test suite

```
rspec
```

CircleCI is set up for the app, I think you might have access to the builds, since it's public, but let me know if you don't see it.


## What are we building?

Software to support the core work of the New Sanctuary Coalition: helping our friends fill out applications for asylum and accompanying them to their hearings and check-ins.

### User Roles
- Admin (has access to everything)
- Volunteer (has limited access)


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
1. Select a story from the Trello board.
2. Create a feature branch off master.
3. Complete feature with tests!
4. Check CircleCI to make sure tests are passing.
5. Make a pull request and tag me, Christine, to review.
6. Merge into master upon approval of the pull request.








