# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Commands to run in local/production based on what code is being changed:

General production commands:
`su - rails`
`systemctl restart rails.service`
`systemctl daemon-reload`

(Source: https://marketplace.digitalocean.com/apps/ruby-on-rails?ipAddress=159.65.164.43#getting-started)

1. if changing css, run `rails assets:precompile`

2. If changing database, `rails db:migrate`