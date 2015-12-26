# E-Store API

It's continuously deployed to Heroku via CircleCI

[![Circle CI](https://circleci.com/gh/JustinFeng/e-store-api.svg?style=shield)](https://circleci.com/gh/JustinFeng/e-store-api)

Demo URL: http(s)://e-store-api.herokuapp.com

## API Document

### SMS

As sending sms will cost $, currently, we have prevented sms being sent and use static '000123' as the code for testing

    desc 'Send SMS'
    POST /api/sms
    requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/

### User Management

Although the code is fixed to '000123', you still need to call /api/sms first to generate the database record before sign up

    desc 'Sign up'
    POST /api/user
    requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
    requires :password, type: String, desc: 'User password', allow_blank: false
    requires :code, type: String, desc: 'Verification code', regexp: /^\d{6}$/
  
    desc 'Change password'
    PUT /api/user/:userid
    requires :password, type: String, allow_blank: false, desc: 'Old user password'
    requires :new_password, type: String, allow_blank: false, desc: 'New user password'
    
    desc 'Sign in'
    POST /api/sign_in
    requires :phone, type: String, desc: 'Phone number', regexp: /^1\d{10}$/
    requires :password, type: String, desc: 'User password', allow_blank: false
    
### User Account
    
TODO

### Product

Don't worry about this for registering in hospital

    desc 'Get All Products'
    GET /api/product
    
    desc 'Get Product Info'
    GET /api/product/:product_id
    
### Order

TODO

### Payment

TODO