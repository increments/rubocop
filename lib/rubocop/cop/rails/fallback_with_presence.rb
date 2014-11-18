# encoding: utf-8

module RuboCop
  module Cop
    module Rails
      # FIXME
      class FallbackWithPresence < Cop
        def on_if(if_node)
          return if if_node.parent && if_node.parent.if_type?

          condition, true_body, false_body = *if_node
          return unless condition.send_type?

          receiver, message, *args = *condition
          return unless message == :present?
          return unless args.empty?

          return if receiver != true_body &&
                    !(receiver.nil? && true_body.self_type?)

          message = "Use `presence` as `#{new_source(receiver, false_body)}`."
          add_offense(if_node, :expression, message)
        end

        def new_source(receiver, false_body)
          lhs_source = ''
          lhs_source << receiver.loc.expression.source + '.' if receiver
          lhs_source << 'presence'

          rhs_souce = false_body.loc.expression.source

          "#{lhs_source} || #{rhs_souce}"
        end
      end
    end
  end
end
