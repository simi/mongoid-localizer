# Mongoid::Localizer [![Build Status](https://travis-ci.org/simi/mongoid-localizer.png?branch=master)](https://travis-ci.org/simi/mongoid-localizer)

[Globalize](https://github.com/svenfuchs/globalize3) alike behaviour for Mongoid localized models.

You can switch localized columns locale context without changing ```I18n.locale```.

Good for administrations, where you want to edit localized documents without changing language for whole page.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-localizer', github: 'simi/mongoid-localizer'
```

And then execute:

    $ bundle

Or install it yourself as (not released yet):

    $ gem install mongoid-localizer

## Usage

```ruby
Mongoid::Localizer.locale # => I18n.locale for default

Mongoid::Localizer.locale = :en
dictionary = Dictionary.create(name: "Otto", description: "English")
Mongoid::Localizer.locale = :de
dictionary.description = "Deutsch"
dictionary.save

Mongoid::Localizer.locale = :en
dictionary.description # => "English"
Mongoid::Localizer.locale = :de
dictionary.description # => "Deutsch"

Mongoid::Localizer.with_locale(:en) do
  dictionary.description # => "English"
end

dictionary.description # => "Deutsch"
```

## Preventing I18n.fallbacks

```ruby
class Dictionary
  include Mongoid::Document
  field :name, type: String
  field :description, type: String, localize: true
  field :slug, type: String, localize: {prevent_fallback: true}
end

Mongoid::Localizer.locale = :en
dictionary = Dictionary.create(name: "Otto", description: "English", slug: "english")

Mongoid::Localizer.locale = :de
dictionary.description => "English"
dictionary.slug => nil
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
