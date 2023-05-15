require 'rails_helper'

RSpec.describe Item, type: :model do
  # must belong to a single todo record
  it { should belong_to(:todo) }
  # name shouldn't be empty
  it { should validate_presence_of(:name) }
end
