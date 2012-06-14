require 'spec_helper'

describe Puddle do
  let(:klass) {
    klass = Class.new
    # potential options, init size, max size, allocation types, pre-alloc?
    # default pool size of 1, grow by doubling, do pre-aloc
    klass.send :include, Puddle
    klass
  }
  it 'returns an object of the correct class' do
    particle = klass.drink
    particle.class.should == klass
  end

  it 'returns the same object in a pool of one' do
    particle = klass.drink
    particle.spit!
    particle.object_id.should == klass.drink.object_id
  end

  it 'allocates a larger pool if all objects are in use' do
    p1 = klass.drink
    p2 = klass.drink
    p1.object_id.should_not == p2.object_id
    p1.spit!
    p3 = klass.drink
    p1.object_id.should == p3.object_id
  end
end

