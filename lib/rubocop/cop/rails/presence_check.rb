# encoding: utf-8

module RuboCop
  module Cop
    module Rails
      # FIXME
      class PresenceCheck < Cop
        def on_or(or_node)
          lhs, rhs = *or_node

          truthy, lhs_receiver = unwrap_truthy_check(lhs)
          return if truthy

          truthy, rhs_obj = unwrap_truthy_check(rhs)
          return unless truthy

          return unless rhs_obj.send_type?
          rhs_receiver, rhs_message, = *rhs_obj
          return unless rhs_message == :empty?

          return unless lhs_receiver == rhs_receiver

          message = "Use `#{lhs_receiver.loc.expression.source}.blank?`."
          add_offense(or_node, :expression, message)
        end

        def on_and(and_node)
          lhs, rhs = *and_node

          truthy, lhs_receiver = unwrap_truthy_check(lhs)
          return unless truthy

          truthy, rhs_obj = unwrap_truthy_check(rhs)
          return if truthy

          return unless rhs_obj.send_type?
          rhs_receiver, rhs_message, = *rhs_obj
          return unless rhs_message == :empty?

          return unless lhs_receiver == rhs_receiver

          message = "Use `#{lhs_receiver.loc.expression.source}.present?`."
          add_offense(and_node, :expression, message)
        end

        def on_send(send_node)
          receiver, message, = *send_node
          return unless message == :!
          inner_receiver, inner_message, = *receiver
          return unless [:present?, :blank?].include?(inner_message)

          receiver_source = inner_receiver.loc.expression.source
          inverted_message = inner_message == :present? ? :blank? : :present?
          message = "Use `#{receiver_source}.#{inverted_message}`."

          add_offense(send_node, :expression, message)
        end

        private

        def unwrap_truthy_check(node, last_truthy = true)
          return [last_truthy, node] unless node

          if node.send_type?
            receiver, message, = *node

            if [:!, :nil?].include?(message)
              unwrap_truthy_check(receiver, !last_truthy)
            else
              [last_truthy, node]
            end
          else
            [last_truthy, node]
          end
        end
      end
    end
  end
end
