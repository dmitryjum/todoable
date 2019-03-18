# Todoable

This gem wrapps api requests to Todoable API. Available actions are: index (to get all todo lists), create (to create a todo list), get_list (to get one list by id), update (to update a lists name), delete (to update a gem), create_item (to create an item in a list), finish_item(to check an item as finished in a list), delete_item( to delete an item in a list).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage
* The gem isn't released to rubygems.org yet, so it'll have to be downloaded from this repository to your machine before installation.
* In order to be able to use this gem you have to set TODOABLE_USERNAME and TODOABLE_PASSWORD environment variables.
* Require 'todoable' in your ruby file
* Initialize Todoable::Lists class with no arguments, just make sure that your password and username are set as env variables.
```
Todoable::Lists.new
```
* Call methods on your instance. #index doesn't require any arguments, every other method get method requires a hash of arguments. If you're requesting a list, pass a k/v pair {id: 'id'}, if you're requesting and items list that belong to a list, pass both ids as {id: 'id', item_id: 'item_id'}, if you're creating or updating one of them, pass additional k/v pairs as {list: {name: 'name'}} or {item: {item: name}}.
* If Auth Token expires, the gem will reauthorize itself automatically.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dmitryjum/todoable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
