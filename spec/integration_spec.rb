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
      expect(subject.address).to eq(address)
    end
  end

  describe "Persistence" do
    subject { Person.create!(address: address) }

    it "saves" do
      expect(subject.reload.address).to eq(address)
    end
  end

  context "embedded" do
    subject { Person.create!(address: address) }

    it "tracks persisted state" do
      expect(subject.reload.address).to be_persisted
    end

    it "tracks destroyed state" do
      subject.destroy
      expect(subject.address).to be_destroyed
    end

    it "destroys" do
      subject.address.destroy
      expect(subject).not_to be_destroyed
      expect(subject.reload.address).to be_nil
    end

    it "updates" do
      subject.address.number = 17
      subject.address.save
      expect(subject.reload.address.number).to eq(17)
    end

    it "creates" do
      person = Person.new
      address = Address.new(valid_attributes)
      person.address = address
      person.address.save
      expect(person.reload.address).to eq(address)
    end

  end

  describe "Nested attributes" do
    subject { Person.new(address_attributes: valid_attributes) }

    it "assigns" do
      address = subject.address
      expect(address.street).to eq('Birch')
      expect(address.number).to eq(1)
      expect(address.business).to eq(false)
    end

    it "saves" do
      subject.save!
      subject.reload
      address = subject.address
      expect(address.street).to eq('Birch')
      expect(address.number).to eq(1)
      expect(address.business).to eq(false)
    end
  end

  describe "Building" do

    it "builds" do
      address = subject.build_address(valid_attributes)
      expect(address).to be_a_kind_of(Address)
      expect(address.number).to eq(1)
    end

    it "creates" do
      address = subject.create_address(valid_attributes)
      expect(address).to be_a_kind_of(Address)
      expect(address.number).to eq(1)
    end

    it "creates!" do
      address = subject.create_address!(valid_attributes)
      expect(address).to be_a_kind_of(Address)
      expect(address.number).to eq(1)
    end
  end

  describe "Validation" do
    before { subject.address = Address.new }

    context "Invalid" do
      it "validates associated" do
        expect(subject.address).not_to be_valid
        expect(subject).not_to be_valid
        expect(subject.errors['address']).not_to be_empty
      end

      it "doesn't save parent when validation fails" do
        expect(subject.save).to be_falsey
      end
    end
  end
end
