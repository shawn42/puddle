require 'spec_helper'
require 'vector2'

describe Puddle do
#   let(:klass) {
#     klass = Class.new
#     # potential options, init size, max size, allocation types, pre-alloc?
#     # default pool size of 1, grow by doubling, do pre-aloc
#     Puddle.splash(klass)
#     klass
#   }
#   it 'returns an object of the correct class' do
#     particle = klass.drink
#     particle.class.should == klass
#   end
# 
#   it 'returns the same object in a pool of one' do
#     particle = klass.drink
#     particle.spit!
#     particle.object_id.should == klass.drink.object_id
#   end
# 
#   it 'allocates a larger pool if all objects are in use' do
#     p1 = klass.drink
#     p2 = klass.drink
#     p1.object_id.should_not == p2.object_id
#     p1.spit!
#     p3 = klass.drink
#     p1.object_id.should_not == p2.object_id
#   end
# 
#   it 'saves time' do
#     # has to be big enough to get us GC time savings
#     object_count = 10_000_000
# 
#     Puddle.splash(klass, initial_size: 1)
# 
#     pre_time = Time.now
#     object_count.times do
#       obj = klass.drink
#       obj.spit!
#     end
#     post_time = Time.now
#     drink_time = post_time - pre_time
# 
#     pre_time = Time.now
#     object_count.times do
#       obj = klass.new
#     end
#     post_time = Time.now
#     default_alloc_time = post_time - pre_time
# 
#     # drink_time.should < default_alloc_time
#     puts "drink time: #{drink_time} vs default alloc: #{default_alloc_time}"
#   end

  describe 'Vector2 in a puddle' do
    before do
      Puddle.splash(Vector2, initial_size: 1000)
      Vector2.setup 1234
    end

    it 'works' do
      a = Vector2.borrow.set!(4,8)
      b = Vector2.borrow.set!(2,3)
      c = a + b

      Vector2.return(a)
      Vector2.return(b)

      c.x.should == 6
      c.y.should == 11
      Vector2.return(c)

    end
  end
end

