require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Hstore::Document do

  subject { Address.new(street: 'Elm', number: 13) }

  describe "Instantiation" do
    it "builds" do
      subject.street.should eq('Elm')
      subject.number.should eq(13)
    end

    it "has defaults" do
      address = Address.new
      address.street.should eq('unknown')
      address.street = nil
      address.street.should be_nil
    end
  end

  describe "Validations" do
    subject { StrictAddress.new }

    it "validates" do
      subject.street = nil
      subject.should_not be_valid
      subject.errors[:street].should_not be_empty
      subject.errors[:number].should_not be_empty

      subject.street = 'Oak'
      subject.number = 7
      subject.should be_valid
    end
  end

  describe "Serialization" do
    before { subject.business = true }
    let(:data) { %{"street"=>"Elm","number"=>"13","business"=>"t"} }

    it "serializes to json" do
      subject.as_json.should eq({
        'street' => 'Elm',
        'number' => 13,
        'business' => true
      })
    end

    it "serializes to hstore" do
      subject.to_hstore.should eq(data)
      subject.business = false
      subject.to_hstore.should eq(%{"street"=>"Elm","number"=>"13","business"=>"f"})
    end

    it "unserializes from hstore" do
      serialized = if ActiveRecord::VERSION::MAJOR < 4
        data
      else
        {"street"=>"Elm","number"=>"13","business"=>"t"}
      end
      obj = Address.from_hstore(serialized)
      obj.should be_a_kind_of(Address)
      obj.street.should eq('Elm')
      obj.business.should eq(true)
      obj.number.should eq(13)
    end

  end

  describe "State change tracking" do
    subject { Address.new }

    it { should_not be_changed }

    it "is changed when attribute is changed" do
      subject.street = 'Elm'
      subject.should be_changed
    end

    it "destroys" do
      expect { subject.destroy }.to change { subject.destroyed? }.to(true)
    end
  end

  it "raises error when save is attempted" do
    expect { subject.save }.to raise_error(Hstore::Document::OwnerMissingError)
  end
end
