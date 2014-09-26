# hstore-document

This gem allows embedding of an auxillary object in an ActiveRecord::Base model using Hstore.
This brings the niceties of Mongo's embedded documents to PostgreSQL.
It's modelled after Mongoid's embedded documents.

An example is worth a thousand words:

```ruby

  class Person < ActiveRecord::Base
    embeds :address

    # you can even do that:
    accepts_nested_attributes_for :address
  end

  class Address
    include Hstore::Document

    field :street
    field :number, type: Fixnum
    field :zip, type: Fixnum
    field :business, type: Boolean
    # though it's probably a very bad idea to store large arrays
    field :phones, type: Array

    validates_presence_of :street, :number
    validates_numericality_of :number, :zip

    before_validation :check_zip_code

    # etc.
  end

  person = Person.new
  person.address = Address.new(street: 'Elm', number: 'invalid')
  person.save # => false  (validations failed)

  person.address.number = 13
  person.save

  person.address.destroy
```

## TODO

* ActiveRecord 5.0 support
* Query support, e.g. Person.where('address.street' => 'Elm')

## Contributing to hstore-document

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Roman Shterenzon. See LICENSE.txt for further details.
