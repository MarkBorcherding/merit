class AwardedPoint < ActiveRecord::Base
  belongs_to :sash

  attr_accessible :points, :category

  after_create do
    sash.total_points = sash.awarded_points.sum &:points
    sash.save
  end
end
