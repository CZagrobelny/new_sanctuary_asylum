# New Sanctuary Coalition

## Getting setup

#### Database setup
```
rake db:setup
rake db:seed
```
Populate Countries
```
rake ''
```
Populate Languages
```
rake ''
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

Circle CI is set up for the app, I think you might have access to the builds, since it's public, but let me know if you don't see it.

## What are we building?

Software to support the core work of the New Sanctuary Coalition: helping our friends fill out applications for asylum and accompanying them to their hearings and check-ins

### User Roles
Admin (has access to everything)
Volunteer (has limited access. Enough to submit an asylum application for a friend record they are given access to and to sign up to accompany friends)

### We know we have an MVP when...
- An admin can invite new users
- An admin can view/search/edit friends and users
- An admin 




## How are we building it?

### Standard helpers and patterns for forms!
Bootstrap styles
We are using chosen
Ajax to submit forms within modals to centralize the locations that an admin has to interact with the software
Pagination
If there is anything else you think is essential, let's talk about it. Trying to keep the gem list short, reliable, and maintainable..and keep our js libraries under control. 

### Test Coverage!
- model tests
- feature tests to cover the main pathways through the app

### Hosting
somewhere








