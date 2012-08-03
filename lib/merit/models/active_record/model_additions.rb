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
        alias_method :create_sash_if_none, :sash

        has_many :badges, :through => :sash

        def award_points(points)
          sash.awarded_points.create :points => points
        end

      end

    end
  end

end

ActiveRecord::Base.send :include, Merit
