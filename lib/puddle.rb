require "puddle/version"
require "puddle_ext"

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
  module ClassMethods
    def configure_puddle(options={})
      @_puddle = Puddle.new options.merge(klass: self)
    end

    def fill_puddle
      @_puddle.fill
    end

    def drink
      @_puddle.drink
    end

    def spit(object)
      @_puddle.spit(object)
    end
  end

  def self.splash(klass, options = {})
    klass.extend FastClassMethods
    klass.extend ClassMethods
    klass.send :include, self
    klass.configure_puddle options
    klass.fill_puddle
  end

  # returns the object to the puddle
  def spit!
    self.class.spit(self)
    self
  end

  def drink!
    self
  end

  def drank?
    @drank
  end

  class Puddle
    attr_accessor :puddle_options

    def initialize(puddle_options)
      @puddle_options = puddle_options
      @objects = []
      @free_size = puddle_options[:initial_size] || 1
    end

    def increase_max_and_refill
      # puts "increasing from #{@free_size} to #{(@free_size + 1) * 2}"
      @free_size = (@free_size + 1) * 2
      fill @free_size
    end

    def fill(size=nil)
      size ||= @free_size
      size.times do |i|
        # puts "adding object [#{instance.object_id}]"
        @objects.push puddle_options[:klass].new
      end
    end

    def drink
      # puts "drinking, #{@objects.size} left"
      # if @objects.empty?
      #   increase_max_and_refill
      # end
      # @objects.pop
    end

    def spit(object)
      # @objects.push object
    end
  end
end
