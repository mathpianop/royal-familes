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

  describe "#children_by_multiple_spouses?" do
    it "returns true if a person has children by more than one spouse" do
      expect(children_by_multiple_spouses?(people(:john_gaunt).consorts, people(:john_gaunt).children)).to be(true)
    end

    it "returns false if a person has only one spouse" do
      expect(children_by_multiple_spouses?(people(:edward_iv).consorts, people(:edward_iv).children)).to be(false)
    end

    it "returns false if a person has more than one spouse, but children by only one" do
      expect(children_by_multiple_spouses?(people(:henry_iv).consorts, people(:henry_iv).children)).to be(false)
    end
  end

  describe "#children_by_spouse" do
    it "returns all the children the subject has by a given spouse" do
      expect(children_by_spouse(people(:katherine_swynford), people(:john_gaunt).children)).to contain_exactly(
        people(:joan_beaufort),
        people(:john_beaufort)
      )
    end
  end
end
