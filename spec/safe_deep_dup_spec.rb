require 'spec_helper'

describe InheritableInstance::SafeDeepDup do
  describe '.duplicate' do

    def expect_no_duplication(value, check_message: true)
      expect(value).not_to receive(:dup) if check_message
      dupl = described_class.duplicate(value)
      expect(dupl).to equal value
    end

    def expect_duplication(value, check_message: true)
      expect(value).to receive(:dup).and_call_original if check_message
      dupl = described_class.duplicate value
      expect(dupl).not_to equal value
      expect(dupl).to eq value
    end

    context 'nil' do
      it 'does not duplicate' do
        expect_no_duplication nil, check_message: false
      end
    end

    context 'false' do
      it 'does not duplicate' do
        expect_no_duplication false
      end
    end

    context 'true' do
      it 'does not duplicate' do
        expect_no_duplication true
      end
    end

    context 'symbols' do
      it 'do not duplicate' do
        expect_no_duplication :"", check_message: false
        expect_no_duplication :foo, check_message: false
      end
    end

    context 'modules' do
      it 'do not duplicate' do
        expect_no_duplication InheritableInstance
        expect_no_duplication Module.new
      end
    end

    context 'classes' do
      it 'do not duplicate' do
        expect_no_duplication Set
        expect_no_duplication Class.new
      end
    end

    context 'methods' do
      it 'do not duplicate' do
        expect_no_duplication [].method(:each)
        expect_no_duplication Object.instance_method(:to_s)
      end
    end

    context 'numerics' do
      it 'Integer does not duplicate' do
        expect_no_duplication (-5), check_message: false
        expect_no_duplication    0, check_message: false
        expect_no_duplication    5, check_message: false
      end

      it 'Float does not duplicate' do
        expect_no_duplication   (-2.1), check_message: false
        expect_no_duplication      0.0, check_message: false
        expect_no_duplication 12345.67, check_message: false
      end

      it 'BigDecimal does duplicate' do
        expect_duplication BigDecimal.new(-3.14, 2),  check_message: false
        expect_duplication BigDecimal.new(0),         check_message: false
        expect_duplication BigDecimal.new(0.2468, 4), check_message: false
        expect_duplication BigDecimal.new(9000.1, 1), check_message: false
      end
    end

    context 'strings' do
      it 'do duplicate' do
        expect_duplication ''
        expect_duplication 'foo'
        expect_duplication "foo\nbar\nbaz"
      end
    end

    context 'objects' do
      let(:struct) { Struct.new(:value) }

      it 'do duplicate' do
        expect_duplication struct.new(:abc)
      end

      context 'without a :dup method' do
        it 'do not duplicate' do
          obj = struct.new(:abc)
          expect(obj).to receive(:respond_to?).with(:dup).and_return(false)
          expect_no_duplication obj
        end
      end

      context 'that are not duplicable' do
        it 'do not duplicate' do
          obj = struct.new(:abc)
          def obj.duplicable?; false; end
          expect_no_duplication obj
        end
      end
    end

    context 'arrays' do
      it 'duplicate recursively' do
        array = [ 'a', [:b, 'c'], [], :d, [[['e']]] ]
        dupl = described_class.duplicate array
        expect(array).to eq dupl
        array[1].clear
        array[-1][0][0] << :f
        expect(array).not_to eq dupl
      end
    end

    context 'hashes' do
      it 'duplicate keys recursively' do
        key = Object.new
        dup = Object.new
        expect(key).to receive(:dup).and_return(dup)
        hash = { key => :foo }
        dupl = described_class.duplicate hash
        hash[:ignored] = true
        expect(dupl.keys).to eql [dup]
        expect(dupl.values).to eql [:foo]
      end

      it 'duplicate values recursively' do
        string = "one-two-three"
        hash = { abc: string }
        dupl = described_class.duplicate hash
        expect(hash).to eq dupl
        string << "-four"
        expect(hash).not_to eq dupl
      end

      it 'keep the default value through duplication' do
        hash = Hash.new(123456789)
        hash['a'] = "one"
        expect(hash['b']).to eq 123456789
        dupl = described_class.duplicate hash
        expect(dupl['a']).to eq "one"
        expect(dupl['b']).to eq 123456789
        expect(dupl['c']).to eq 123456789
      end

      it 'keep the default proc through duplication' do
        hash = Hash.new{ |h,k| h[k] = "value for #{k.inspect}" }
        hash[4] = "asdf"
        expect(hash[5]).to eq "value for 5"
        dupl = described_class.duplicate hash
        expect(dupl[4]).to eq "asdf"
        expect(dupl[5]).to eq "value for 5"
        expect(dupl[6]).to eq "value for 6"
      end
    end

  end
end
