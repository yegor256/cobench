# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'loog'
require_relative '../lib/cobench/match'

# Test for Match.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestMatch < Minitest::Test
  def test_positive
    loog = Loog::NULL
    opts = { include: [], exclude: [] }
    assert Cobench::Match.new(opts, loog).matches?('foo/bar')
  end

  def test_negative
    loog = Loog::NULL
    opts = { include: ['*/*'], exclude: ['foo/*'] }
    assert !Cobench::Match.new(opts, loog).matches?('foo/bar')
  end
end
