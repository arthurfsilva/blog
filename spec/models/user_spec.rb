require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      name: 'Amy',
      email: 'amything@gmail.com',
      password: 'test123',
      password_confirmation: 'test123'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without name' do
    subject.name = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid without email' do
    subject.email = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid with name length is too short' do
    subject.name = 'a'

    expect(subject).to_not be_valid
  end

  it 'is not valid with password length is too short' do
    subject.password = 'pass'

    expect(subject).to_not be_valid
  end

  it 'is not valid with email invalid' do
    subject.email = 'thisisnotanemail'

    expect(subject).to_not be_valid
  end
end
