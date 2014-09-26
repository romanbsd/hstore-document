require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Hstore::Document do

  subject { Address.new(street: 'Elm', number: 13) }

  describe "Instantiation" do
    it "builds" do
      expect(subject.street).to eq('Elm')
      expect(subject.number).to eq(13)
    end

    it "has defaults" do
      address = Address.new
      expect(address.street).to eq('unknown')
      address.street = nil
      expect(address.street).to be_nil
    end
  end

  describe "Validations" do
    subject { StrictAddress.new }

    it "validates" do
      subject.street = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:street]).not_to be_empty
      expect(subject.errors[:number]).not_to be_empty

      subject.street = 'Oak'
      subject.number = 7
      expect(subject).to be_valid
    end
  end

  describe "Serialization" do
    before { subject.business = true }
    let(:data) { %{"street"=>"Elm","number"=>"13","business"=>"t"} }

    it "serializes to json" do
      expect(subject.as_json).to eq({
        'street' => 'Elm',
        'number' => 13,
        'business' => true
      })
    end

    it "serializes to hstore" do
      expect(subject.to_hstore).to eq(data)
      subject.business = false
      expect(subject.to_hstore).to eq(%{"street"=>"Elm","number"=>"13","business"=>"f"})
    end

    it "unserializes from hstore" do
      serialized = if ActiveRecord::VERSION::MAJOR < 4
        data
      else
        {"street"=>"Elm","number"=>"13","business"=>"t"}
      end
      obj = Address.from_hstore(serialized)
      expect(obj).to be_a_kind_of(Address)
      expect(obj.street).to eq('Elm')
      expect(obj.business).to eq(true)
      expect(obj.number).to eq(13)
    end

  end

  describe "State change tracking" do
    subject { Address.new }

    it { is_expected.not_to be_changed }

    it "is changed when attribute is changed" do
      subject.street = 'Elm'
      expect(subject).to be_changed
    end

    it "destroys" do
      expect { subject.destroy }.to change { subject.destroyed? }.to(true)
    end
  end

  it "raises error when save is attempted" do
    expect { subject.save }.to raise_error(Hstore::Document::OwnerMissingError)
  end
end
