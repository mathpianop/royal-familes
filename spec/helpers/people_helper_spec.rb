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
      family = Family.new(people(:john_gaunt))
      expect(subject_level_people(people(:john_gaunt), family.siblings)).to eq([
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
      family = Family.new(people(:john_gaunt))
      expect(children_by_multiple_spouses?(family.spouses, family.children)).to be(true)
    end

    it "returns false if a person has only one spouse" do
      family = Family.new(people(:edward_iv))
      expect(children_by_multiple_spouses?(family.spouses, family.children)).to be(false)
    end

    it "returns false if a person has more than one spouse, but children by only one" do
      family = Family.new(people(:henry_iv))
      expect(children_by_multiple_spouses?(family.spouses, family.children)).to be(false)
    end
  end

  describe "#children_by_spouse" do
    it "returns all the children the subject has by a given spouse" do
      family = Family.new(people(:john_gaunt))
      expect(children_by_spouse(people(:katherine_swynford), family.children)).to contain_exactly(
        people(:joan_beaufort),
        people(:john_beaufort)
      )
    end
  end
end
