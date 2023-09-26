require 'rails_helper'
require 'securerandom'

RSpec.describe Comment, type: :model do
  fixtures :all

  subject do
    @post = posts(:first)

    described_class.new(
      name: 'My Name',
      body: 'This is an body',
      post: @post
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without name' do
    subject.name = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid without body' do
    subject.body = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid with name length is too short' do
    subject.name = 'a'

    expect(subject).to_not be_valid
  end

  it 'is not valid with name length is too long' do
    subject.name = SecureRandom.alphanumeric(51)

    expect(subject).to_not be_valid
  end

  it 'is not valid with body length is too short' do
    subject.body = 'a'

    expect(subject).to_not be_valid
  end
end
