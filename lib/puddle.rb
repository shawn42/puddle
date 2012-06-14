require "puddle/version"

# modifies this class to be pulled from an object pool
# class Foo
#   include Puddle
# end
#
# # requests an available instance of Foo
# foo = Foo.drink 
# .. use foo ..
#
# # puts foo back in the puddle
# foo.spit
module Puddle
  def self.included(klass)
    klass.send :define_singleton_method, :fill_puddle do
      @_puddle_size ||= 1
      @_puddles ||= []

      (@_puddle_size - @_puddles.size).times do
        @_puddles << klass.new
      end

    end

    klass.send :define_singleton_method, :drink do
      @_puddles ||= []
      available = @_puddles.detect do |puddle|
        !puddle.drank?
      end
      if available.nil?
        @_puddle_size *= 2
        fill_puddle
        available = drink
      end

      available.drink!

    end

    klass.fill_puddle

  end

  # returns the object to the puddle
  def spit!
    @drank = false
    self
  end

  def drink!
    @drank = true
    self
  end

  def drank?
    @drank
  end


end
