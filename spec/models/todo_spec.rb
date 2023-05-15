require 'rails_helper'

RSpec.describe Todo, type: :model do

  # make sure Todo model has 1:m relationship with Item model
  it {should have_many(:items).dependent(:destroy) }
  # make sure the title and created by are not empty
  it {should validate_presence_of(:title) }
  it {should validate_presence_of(:created_by)}
end
