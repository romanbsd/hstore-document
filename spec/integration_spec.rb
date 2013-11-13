require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Embedded" do

  subject { Person.new }
  let(:address) { Address.new(street: 'Elm', number: 13) }

  let(:valid_attributes) do
    {street: 'Birch', number: 1, business: false}
  end

  describe "Assignment" do
    it "assigns" do
      subject.address = address
      subject.address.should eq(address)
    end
  end

  describe "Persistence" do
    subject { Person.create!(address: address) }

    it "saves" do
      subject.reload.address.should eq(address)
    end
  end

  context "embedded" do
    subject { Person.create!(address: address) }

    it "tracks persisted state" do
      subject.reload.address.should be_persisted
    end

    it "tracks destroyed state" do
      subject.destroy
      subject.address.should be_destroyed
    end

    it "destroys" do
      subject.address.destroy
      subject.should_not be_destroyed
      subject.reload.address.should be_nil
    end

    it "updates" do
      subject.address.number = 17
      subject.address.save
      subject.reload.address.number.should eq(17)
    end

    it "creates" do
      person = Person.new
      address = Address.new(valid_attributes)
      person.address = address
      person.address.save
      person.reload.address.should eq(address)
    end

  end

  describe "Nested attributes" do
    subject { Person.new(address_attributes: valid_attributes) }

    it "assigns" do
      address = subject.address
      address.street.should eq('Birch')
      address.number.should eq(1)
      address.business.should eq(false)
    end

    it "saves" do
      subject.save!
      subject.reload
      address = subject.address
      address.street.should eq('Birch')
      address.number.should eq(1)
      address.business.should eq(false)
    end
  end

  describe "Building" do

    it "builds" do
      address = subject.build_address(valid_attributes)
      address.should be_a_kind_of(Address)
      address.number.should eq(1)
    end

    it "creates" do
      address = subject.create_address(valid_attributes)
      address.should be_a_kind_of(Address)
      address.number.should eq(1)
    end

    it "creates!" do
      address = subject.create_address!(valid_attributes)
      address.should be_a_kind_of(Address)
      address.number.should eq(1)
    end
  end

  describe "Validation" do
    before { subject.address = Address.new }

    context "Invalid" do
      it "validates associated" do
        subject.address.should_not be_valid
        subject.should_not be_valid
        subject.errors['address'].should_not be_empty
      end

      it "doesn't save parent when validation fails" do
        subject.save.should be_false
      end
    end
  end
end
