require 'spec_helper'

describe InheritableInstance do
  it 'has a version number' do
    expect(InheritableInstance::VERSION).not_to be nil
  end

  let(:parent) { Class.new{ extend InheritableInstance } }
  let(:child) { Class.new(parent) }
  let(:grandchild) { Class.new(child) }

  def get(obj, ivar); obj.instance_variable_get(ivar); end

  context 'inheritable_instance' do
    it 'sets the instance variable' do
      parent.inheritable_instance :@thing, []
      expect(get(parent, :@thing)).to eql []
    end

    it 'overwrites an existing variable' do
      parent.inheritable_instance :@thing, 1
      parent.inheritable_instance :@thing, 2
      parent.inheritable_instance :@thing, 3
      expect(get(parent, :@thing)).to eql 3
    end
  end

  context 'inherited' do
    it 'sets the inherited variables on the child class' do
      parent.instance_variable_set :@thing, []
      parent.inheritable_instance '@w00t', 0
      parent.inheritable_instance :@thing, {}
      expect(get(child, :@thing)).to eql Hash.new
      expect(get(child, :@w00t)).to eql 0
    end

    it 'sets the inherited variables on more distant descendants' do
      parent.inheritable_instance '@abc', 123
      expect(get(grandchild, :@abc)).to eql 123
    end

    it 'duplicates the parent value' do
      expect(value = Object.new).to receive(:dup).and_return(dup = Object.new)
      parent.inheritable_instance '@key', value
      expect(get(child, :@key)).to equal dup
    end
  end
end
