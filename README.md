# Simple Timeout

A simple implementation of Timeout.

The standard `Timeout::timeout` will always wait until the block finishes execution, and then, when the thread where the block is being executed can't be killed for some reason, your whole program get blocked. `SimpleTimeout::timeout` lets you choose if you want to wait for the block to finish execution or not. By default it won't wait.

[![Build Status](https://travis-ci.org/simon0191/simple_timeout.svg)](https://travis-ci.org/simon0191/simple_timeout)
[![Code Climate](https://codeclimate.com/github/simon0191/simple_timeout/badges/gpa.svg)](https://codeclimate.com/github/simon0191/simple_timeout)
[![Test Coverage](https://codeclimate.com/github/simon0191/simple_timeout/badges/coverage.svg)](https://codeclimate.com/github/simon0191/simple_timeout/coverage)
[![Gem Version](https://badge.fury.io/rb/simple_timeout.svg)](https://badge.fury.io/rb/simple_timeout)

## Usage

Basic usage:

```ruby
SimpleTimeout::Timeout(5) do
  # Some code that should not take more than 5 seconds
end
```

## Options

`SimpleTimeout::timeout` receives 4 parameters:

```ruby
def self.timeout(seconds,timeout_error_class=SimpleTimeout::Error,wait_for_block=false,&block)
  # the implementation ...
end
```

* **seconds:** How much seconds to wait before raise `timeout_error_class`.
* **timeout_error_class:** The error to raise in case of timeout.
* **wait_for_block:** This one is the main reason for me to implement this gem. The standard `Timeout::timeout` will always wait until the block finishes execution, and then, when the thread where the block is been executed can't be killed for some reason, your whole program get blocked. `SimpleTimeout::timeout` lets you choose if you want to wait for the block to finish execution or not. By default it won't wait.
* **block:** The block to execute.


## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'simple_timeout'
```

And then execute:

```sh
bundle
```

## History

View the [changelog](https://github.com/simon0191/simple_timeout/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/simon0191/simple_timeout/issues)
- Fix bugs and [submit pull requests](https://github.com/simon0191/simple_timeout/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
