# Threads

## Description

**Threads** is a simple anonymous discussion tool.  

To discuss current or potential uses, see our new [Threads forum](https://github.com/berkmancenter/threads/discussions). 

## Dev environment

### Stack

* Ruby on Rails 5.2
* Ruby 2.4.1
* Puma
* Redis
* Postgresql 9.6.x

### Docker

* `cp .env.example .env`
* `docker-compose up`
* `docker-compose exec website sh`
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* The application will be available at `http://localhost:3000`

### Tests

* `bundle exec rspec spec`

## License

MIT
