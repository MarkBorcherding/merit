module Merit
  extend ActiveSupport::Concern

  module ClassMethods

    def has_merit?
      false
    end

    def has_merit
      return if has_merit?
      def self.has_merit?
        true
      end
      include Merit::ModelAdditions # ORM specific
    end

  end

  module InstanceMethods
    def has_merit?
      self.class.has_merit?
    end
  end
end


