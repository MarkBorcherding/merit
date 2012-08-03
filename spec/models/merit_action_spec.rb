require 'spec_helper'

describe MeritAction do

  Object.send(:remove_const, :PointRules) if defined? PointRules
  class PointRules
    include Merit::PointRulesMethods
  end


end
