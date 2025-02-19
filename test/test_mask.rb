# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/cobench/mask'

# Test for Mask.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestMask < Minitest::Test
  def test_positive
    assert Cobench::Mask.new('*/*').matches?('foo/bar')
    assert Cobench::Mask.new('test/*').matches?('Test/one')
    assert Cobench::Mask.new('test/hello').matches?('test/Hello')
  end

  def test_negative
    assert !Cobench::Mask.new('*/*').matches?('some text')
    assert !Cobench::Mask.new('test/*').matches?('best/two')
    assert !Cobench::Mask.new('test/hello').matches?('test/hello2')
  end
end
