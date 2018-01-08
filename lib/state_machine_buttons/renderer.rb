# frozen_string_literal: true

module StateMachineButtons
  module Renderer
    def state_events_buttons(object, state_method: :state, route_method: nil, parameters: {}, without: nil, namespace: nil, model_param_name: nil)
      model_name = object.model.model_name.name.underscore
      model_param_name ||= model_name
      excepted_actions = without.is_a?(Array) ? without.map(&:to_sym) : [without.to_sym] if without
      transitions = object.model.send("#{state_method}_transitions").reject do |t|
        excepted_actions.present? && excepted_actions.include?(t.event)
      end
      content_tag(:div, class: 'btn-group-vertical') do
        transitions.each do |event|
          button event: event, model_name: model_name, object: object, state_method: state_method, route_method: route_method, namespace: namespace, parameters: parameters, model_param_name: model_param_name
        end
      end
    end

    private

    def button(event:, model_name:, object:, state_method:, route_method:, namespace:, parameters:, model_param_name:)
      route_method ||= "#{namespace.present? ? "#{namespace}_": ""}#{model_name.gsub('/', '_')}_path"
      href = send route_method, object.model, parameters.merge(model_param_name => { state_method => event.to })
      concat(
        link_to(
          href,
          class: "btn btn-sm btn-xs btn-#{object.send("#{state_method}_button_color", event.event)}",
          method: :patch
        ) do
          object.class.send "human_#{state_method}_event_name", event.event
        end
      )
    end
  end
end
