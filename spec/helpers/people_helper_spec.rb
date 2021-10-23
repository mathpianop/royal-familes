require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PeopleHelper. For example:
#
# describe PeopleHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PeopleHelper, type: :helper do
  fixtures :people, :marriages

  describe "#subject_level_people" do
    it "returns an array sorted by birth date" do
      expect(subject_level_people(people(:john_gaunt), people(:john_gaunt).siblings)).to eq([
        people(:black_prince),
        people(:lionel),
        people(:john_gaunt),
        people(:edmund_of_york),
        people(:thomas_of_woodstock)
      ])
    end
  end
end
