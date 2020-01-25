# frozen_string_literal: true

module StateMachineButtons
  module Renderer
    def state_events_buttons(object, state_method: :state, controller:, action:, parameters: {}, without: nil, namespace: nil, model_param_name: nil, button_options: {})
      model_name = object.model.model_name.name.underscore
      model_param_name ||= model_name
      excepted_actions = without.is_a?(Array) ? without.map(&:to_sym) : [without.to_sym] if without
      transitions = object.model.send("#{state_method}_transitions").reject do |t|
        excepted_actions.present? && excepted_actions.include?(t.event)
      end
      content_tag(:div, class: 'btn-group-vertical') do
        transitions.each do |event|
          button(
            event: event.event,
            model_name: model_name,
            object: object,
            state_method: state_method,
            controller: controller,
            action: action,
            namespace: namespace,
            parameters: parameters,
            model_param_name: model_param_name,
            form_options: button_options
          )
        end
      end
    end

    private

    def button(event:, model_name:, object:, state_method:, controller:, action:, namespace:, parameters:, model_param_name:, form_options:)
      attributes = { "#{state_method}_event" => event }
      concat(
        patch_button(
          record: object.model,
          controller: controller,
          action: action,
          parameters: parameters,
          attributes: attributes,
          model_name: model_param_name,
          button_options: { class: "btn btn-sm btn-xs btn-#{object.send("#{state_method}_button_color", event)}" },
          form_options: form_options
        ) do
          object.class.send "human_#{state_method}_event_name", event
        end
      )
    end
  end
end
