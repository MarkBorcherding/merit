module Merit
  extend ActiveSupport::Concern

  module ClassMethods

    # Lets us decide if a class can accept merit
    def meritable?() false end

    def has_merit(options = {})
      return if meritable?
      class_eval do
        def meritable?() true end

        has_one :sash, :as => :sashable
        alias_method :original_sash, :sash
        def sash() original_sash || create_sash end
        alias_method :create_sash_if_none, :sash # TODO remove this eventually

        delegate :badges, :to => :sash

        def award_points(points, options={})
          params = {
            :points => points,
            :category => options[:in]
          }
          sash.awarded_points.create params

          # TODO Move this stuff to sash so we don't need to save User to add points.
          # We can just save Sash. We can also move it to counter cache or the like instead
          # of just doing it manually.
          self.points = sash.awarded_points.sum(&:points)
          save :validate => false
        end
      end
    end

  end
end

ActiveRecord::Base.send :include, Merit
