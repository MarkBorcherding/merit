module Merit
  module ModelAdditions
    extend ActiveSupport::Concern

    included do
      has_one :sash, :as => :sashable
      alias_method :original_sash, :sash
      alias_method :sash, :lazy_sash_replacement
      alias_method :create_sash_if_none, :lazy_sash_replacement # TODO remove this eventually

      delegate :badges, :to => :sash
    end

    # Aliased to just #sash. I'm not sure how to get the order just right with the include block
    # to let me alias it without having a silly name like this
    def lazy_sash_replacement
      original_sash || create_sash
    end

    def award_points(points, options={})
      sash.awarded_points.create :points => points, :category => options[:in]

      # TODO Move this stuff to sash so we don't need to save User to add points.
      # We can just save Sash. We can also move it to counter cache or the like instead
      # of just doing it manually.
      self.points = sash.awarded_points.sum(&:points)
      save :validate => false
    end

  end
end

ActiveRecord::Base.send :include, Merit
