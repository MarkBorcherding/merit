module Merit
  # Points are a simple integer value which are given to "meritable" resources
  # according to rules in +app/models/merit_point_rules.rb+. They are given on
  # actions-triggered.
  module PointRulesMethods
    # Define rules on certaing actions for giving points
    def score(points, *args, &block)
      options = args.extract_options!

      actions = [options[:on]].flatten
      targets = [options[:to] || :action_user].flatten
      categories = [options[:in]].flatten

      actions.each do |action|
        actions_to_point[action] = {
          :to => targets,
          :score => points,
          :in => categories
        }
      end
    end

    # Currently defined rules
    def actions_to_point
      @actions_to_point ||= {}
    end
  end
end
