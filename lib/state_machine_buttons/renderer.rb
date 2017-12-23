# frozen_string_literal: true

module StateMachineButtons
  module Renderer
    def state_events_buttons(object, state_method: :state, url: nil, without: nil)
      model_name = object.model.model_name.name.underscore
      excepted_actions = without.is_a?(Array) ? without.map(&:to_sym) : [without.to_sym]
      transitions = object.model.send("#{state_method}_transitions").reject do |t|
        excepted_actions.include? t.event
      end
      content_tag(:div, class: 'btn-group-vertical') do
        transitions.each do |event|
          button event: event, model_name: model_name, object: object, state_method: state_method, url: url
        end
      end
    end

    private

    def button(event:, model_name:, object:, state_method:, url:)
      href = url || send("admin_#{model_name}_path", object.model, model_name => { state_method => event.to })
      concat(
        link_to(
          href,
          class: "btn btn-sm btn-xs btn-#{object.send("#{state_method}_button_color", event.event)}",
          method: :patch
        ) do
          t("state_machines.#{model_name}.#{state_method}.events.#{event.event}")
        end
      )
    end
  end
end
