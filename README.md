# InheritableInstance

Allow descending classes to inherit instance variables.
This is useful for persisting class-level configuration.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'inheritable_instance'
```

## Usage

Insert the InheritableInstance module into your class's ancestor chain:
```ruby
class FakeClass
  extend InheritableInstance
end
```

Then use `inheritable_instance` to set any instance variables
that you want to be inherited by subclasses:
```ruby
class FakeClass
  inheritable_instance :@thing_one, 1
  inheritable_instance :@thing_two, 2
end
```

These variables will be automatically set on inheritance:
```ruby
class DoubleFake < FakeClass; end
DoubleFake.instance_variable_get(:@thing_one) == 1
DoubleFake.instance_variable_get(:@thing_two) == 2
```

It is convenient to pair this with the attr_* methods:
```ruby
class << FakeClass
  attr_accessor :thing_two
end
DoubleFake.thing_two = "two"
FakeClass.thing_two == 2
DoubleFake.thing_two == "two"
```

Note that the values are duplicated (when possible):
```ruby
class OneTwoThree
  extend InheritableInstance
  inheritable_instance :@list, []
  class << self; attr_reader :list; end
end
OneTwoThree.list << 1 << 2 << 3
Abc = Class.new(OneTwoThree)
Abc.list << 'a' << 'b' << 'c'
Abc.list == [1,2,3,'a','b','c']
OneTwoThree.list == [1,2,3]
```

## Additional Details

If for some reason it is inconvenient to `extend` the module,
there is an `Includible` helper that you can use instead:
```ruby
class SameAsFakeClass
  include InheritableInstance::Includible
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fledman/inheritable_instance.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

