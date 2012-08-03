require "merit/models/#{Merit.orm}/merit_action"

class MeritAction
  attr_accessible :user_id, :action_method, :action_value, :had_errors, :target_model, :target_id, :processed, :log

  # Check rules defined for a merit_action
  def check_rules
    unless had_errors
      check_badge_rules
      check_point_rules
    end
    processed!
  end

  def check_badge_rules
    defined_rules = Merit::BadgeRules.new.defined_rules["#{target_model}\##{action_method}"]
    return if defined_rules.nil?

    defined_rules.each do |rule|
      rule.grant_or_delete_badge(self)
    end
  end

  def actions_to_point
    @actions_to_point ||= Merit::PointRules.new.actions_to_point["#{target_model}\##{action_method}"] || []
  end

  def check_point_rules
    return if actions_to_point.nil?

    actions_to_point.each do |point_rule|
      point_rule[:to].each do |to|
        target(to).award_points point_rule[:score], :in => point_rule[:in]
        log!("points_granted:#{point_rule[:score]}")
      end
    end
  end

  def target(to)
    @target ||= if to == :action_user
                  action_user
                else
                  other_target(to)
                end
  end

  def action_user
    begin
      Merit.user_model.find_by_id!(user_id)
    rescue
      Rails.logger.warn "[merit] no user found to grant points" unless user
      return
    end
  end

  def other_target(to)
      begin
        target_object.send(to)
      rescue NoMethodError
        Rails.logger.warn "[merit] No target_object found on check_rules."
        return
      end
  end



  # Action's target object
  def target_object(model_name = nil)
    # Grab custom model_name from Rule, or target_model from MeritAction triggered
    klass = model_name || target_model
    klass.singularize.camelize.constantize.find_by_id(target_id)
  rescue => e
    Rails.logger.warn "[merit] no target_object found: #{e}"
  end

  def log!(str)
    self.log = "#{self.log}#{str}|"
    self.save
  end

  # Mark merit_action as processed
  def processed!
    self.processed = true
    self.save
  end
end
