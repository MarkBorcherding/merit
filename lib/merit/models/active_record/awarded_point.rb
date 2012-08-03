class AwardedPoint < ActiveRecord::Base
  belongs_to :sash

  attr_accessible :points, :category
end
