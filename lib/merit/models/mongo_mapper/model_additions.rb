module Merit
  module ModelAdditions
    extend ActiveSupport::Concern

    module ClassMethods
      def has_merit(options = {})
        plugin Merit
        key :sash_id, String
        key :points, Integer, :default => 0
        key :level, Integer, :default => 0
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
end
MongoMapper::Document.plugin Merit
