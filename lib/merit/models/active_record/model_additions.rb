module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      has_one :sash, :as => :sashable
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

ActiveRecord::Base.send :include, Merit
