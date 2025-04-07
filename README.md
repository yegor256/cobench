<img alt="cobench logo" src="/logo.svg" width="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/cobench)](https://www.rultor.com/p/yegor256/cobench)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/cobench/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/cobench/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=yegor256/cobench)](https://www.0pdd.com/p?name=yegor256/cobench)
[![Gem Version](https://badge.fury.io/rb/cobench.svg)](https://badge.fury.io/rb/cobench)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/cobench/blob/master/LICENSE.txt)
[![Maintainability](https://api.codeclimate.com/v1/badges/396ec0584e0a84adc723/maintainability)](https://codeclimate.com/github/yegor256/cobench/maintainability)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/cobench.svg)](https://codecov.io/github/yegor256/cobench?branch=master)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/cobench)](https://hitsofcode.com/view/github/yegor256/cobench)

This simple script will help you collect statistics about your
programmers and generate a simple HTML report. First, install it:

```bash
$ gem install cobench
```

Then, run it locally and read its output:

```bash
$ cobench --coder yegor256 --verbose
```

This is how our report [looks like](https://github.com/cqfn/bench).

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
