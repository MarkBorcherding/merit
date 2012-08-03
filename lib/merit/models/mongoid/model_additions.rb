module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
        field :sash_id
        field :points, :type => Integer, :default => 0
        field :level, :type => Integer, :default => 0
    end

    def find_by_id(id)
      here(:_id => id).first
    end
  end

  def award_points(points)
    create_sash_if_none
    sash.awarded_points.create :points => points
  end

  def badges
    create_sash_if_none
    sash.badge_ids.collect{|b_id| Badge.find(b_id) }
  end

  # Create sash if doesn't have
  def create_sash_if_none
    if self.sash.blank?
      self.sash = Sash.create
      self.save(:validate => false)
    end
  end
end

Mongoid::Document.send :include, Merit
