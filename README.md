# README

* Ruby version - 2.7.2

* Rails version - 6.1.3.2

## Steps to setup:

1. Clone the repository to a local directory.

2. Execute the following commands:

- bundle install
- rails db:setup
- rails s

## Endpoint details:

### User endpoints: 

1. __GET {{domain}}/users__  
Fetches all users existing in the database.

2. __GET {{domain}}/users/1__  
Fetches User with id 1 if it exists in the database, else responds with a 404.

3. __POST {{domain}}/users__  
Creates user with the parameters in the request payload.
Expected payload:
```
{
    "user": {
        "name": "test user 1",
        "email": "test1@user.com"
    }
}
```
4. __PATCH {{domain}}/users/1__  
Updates user with the parameters in the request payload.
Expected payload:
```
{
    "user": {
        "name": "test user 2"
    }
}
```

5. __DELETE {{domain}}/users/2__  
Deletes the user with id: 2.

### GroupEvents endpoints: 

1. __GET {{domain}}/group_events__  
Fetches all group_events existing in the database.

2. __GET {{domain}}/group_events/1__  
Fetches group_event with id 1 if it exists in the database, else responds with a 404.

3. __POST {{domain}}/group_events__  
Creates user with the parameters in the request payload. Mandatory parameters are name and user_id.
Expected payload:
```
{
    "group_event": {
        "name": "test user 1",
        "user_id": 1,
        "description": "Hello world",
        "start_date": "2021-05-01",
        "duration": 3
    }
}
```
4. __PATCH {{domain}}/group_events/1__  
Updates group_event 1 with the parameters in the request payload.
Expected payload:
```
{
    "group_event": {
        "end_date": "2021-06-01",
        "address": "303 E Elmwood",
        "city": "burbank"
    }
}
```

5. __DELETE {{domain}}/group_events/2__  
Deletes the group_events with id: 2.


6. __POST {{domain}}/group_events/1/publish__  
Publishes the group event 1. In case of errors, it responds with a 500 error.
