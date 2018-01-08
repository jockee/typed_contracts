require "typed_contracts/version"
require "contracts"
require "kleisli"

module TypedContracts
  def self.included(base)
    base.include(::Contracts::Core)
    base.include(::Contracts::Builtin)
  end

  class MaybeOf < ::Contracts::CallableClass
    attr_reader :vals
    def initialize(*vals)
      @vals = vals
    end

    def to_s
      "MaybeOf[#{@vals.first}]"
    end

    def valid?(val)
      return false unless val.is_a?(Kleisli::Maybe) && @vals.size == 1

      inner_valid, = Contract.valid?(val.value, @vals.first)
      inner_valid || val.value.nil?
    end
  end

  class PresentMaybeOf < MaybeOf; end

  class EitherOf < ::Contracts::CallableClass
    def initialize(*vals)
      @vals = vals
    end

    def to_s
      "EitherOf[#{@vals.first}, #{@vals.last}]"
    end

    def monad_valid(val)
      [Kleisli::Either::Left, Kleisli::Either::Right].include?(val.class)
    end

    def valid?(val)
      return false unless monad_valid(val) && @vals.size == 2

      left_valid, = Contract.valid?(val.left, @vals.first)
      right_valid, = Contract.valid?(val.right, @vals.last)
      (val.left.nil? && right_valid) || (val.right.nil? && left_valid)
    end
  end
end
