require 'benchmark'
require '../lib/puddle'
object_count = 10_000_000
timing_sample_count = 10_000

#  Add methods to Enumerable, which makes them available to Array
module Enumerable
 
  #  sum of an array of numbers
  def sum
    return self.inject(0){|acc,i|acc +i}
  end
 
  #  average of an array of numbers
  def average
    return self.sum/self.length.to_f
  end
 
  #  variance of an array of numbers
  def sample_variance
    avg=self.average
    sum=self.inject(0){|acc,i|acc +(i-avg)**2}
    return(1/self.length.to_f*sum)
  end

  def variances
    avg=self.average
    self.map{|i|i-avg}
  end
 
  #  standard deviation of an array of numbers
  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
 
end  #  module Enumerable

class Foo
  # def self.drink
  #   @obj ||= new
  # end
  # def self.spit(obj)
  # end
end

class Class
  alias :neww :new
end

klass = Foo
Puddle.splash(klass, initial_size: 1)

a = [klass.new]
include Benchmark

Benchmark.benchmark(CAPTION, 14) do |x|
  klass.setup 8
  c_puddle_times = []
  x.report('C puddle') do
    last_time = Time.now.to_f
    object_count.times do |i|
      if i % timing_sample_count == 0
        current_time = Time.now.to_f 
        c_puddle_times.push((last_time-current_time)*1000)
        last_time = current_time
      end
      obj = klass.borrow
      klass.return(obj)
    end
  end
  puts "C puddle GC stdev: #{c_puddle_times.standard_deviation}"
  puts "C puddle GC max variance #{c_puddle_times.variances.max}"
  puts "C puddle GC stat: #{GC.stat}"

  # x.report('push pop') do
  #   object_count.times do
  #     obj = a.pop
  #     a.push obj
  #   end
  # end

  # x.report('puddle') do
  #   object_count.times do
  #     obj = klass.drink
  #     klass.spit(obj)
  #   end
  # end
  # x.report('direct puddle') do
  #   puddle = klass.instance_variable_get("@_puddle")
  #   object_count.times do
  #     # obj = klass.drink
  #     # klass.spit(obj)
  #     obj = puddle.drink
  #     puddle.spit obj
  #   end
  # end

  new_times = []
  x.report('new') do
    last_time = Time.now.to_f
    object_count.times do |i|
      if i % timing_sample_count == 0
        current_time = Time.now.to_f 
        new_times.push((last_time-current_time)*1000)
        last_time = current_time
      end
      obj = klass.new
    end
  end
  puts "new GC stdev #{new_times.standard_deviation}"
  puts "new GC max variance #{new_times.variances.max}"
  puts "new GC stat: #{GC.stat}"
end
