require 'state_machine_buttons/version'
require 'state_machine_buttons/renderer'

ActionView::Base.send :include, StateMachineButtons::Renderer
