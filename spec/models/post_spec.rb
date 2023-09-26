require 'rails_helper'
require 'securerandom'

RSpec.describe Post, type: :model do
  fixtures :all

  subject do
    @user = users(:brian)

    described_class.new(
      title: 'My Title',
      content: 'This is an content',
      user: @user
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without title' do
    subject.title = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid without content' do
    subject.content = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid with title length is too short' do
    subject.title = 'a'

    expect(subject).to_not be_valid
  end

  it 'is not valid with title length is too long' do
    subject.title = SecureRandom.alphanumeric(51)

    expect(subject).to_not be_valid
  end

  it 'is not valid with content length is too short' do
    subject.content = 'pass'

    expect(subject).to_not be_valid
  end
end
