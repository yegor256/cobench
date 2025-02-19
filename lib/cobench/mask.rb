# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'version'

# Mask to apply for a repo name.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Cobench::Mask
  def initialize(txt)
    @org, @repo = txt.downcase.split('/')
  end

  def matches?(repo)
    org, repo = repo.downcase.split('/')
    return false if ['', nil].include?(org)
    return false if ['', nil].include?(repo)
    return false if org != @org && @org != '*'
    return false if repo != @repo && @repo != '*'
    true
  end
end
