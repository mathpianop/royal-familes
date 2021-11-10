require 'rails_helper'

RSpec.describe Relationship, type: :model do
  fixtures :people, :marriages
  
  describe "#relationship_info" do

    it "works for relationship with self" do
      relationship_info = people(:edward_iii).relationship_info(people(:edward_iii))
      expect(relationship_info[:relationship]).to eq("Self")
    end

    it "returns lowest_common_ancestors with name and id" do
      relationship_info = people(:john_gaunt).relationship_info(people(:black_prince))
      dad = relationship_info[:lowest_common_ancestors].find do |person| 
        person.name == "Edward III"
      end
    
      expect(dad.id).to eq(people(:edward_iii).id)
    end

    it "does not return lowest_common_ancestors for a direct descendant" do
      relationship_info = people(:edward_iii).relationship_info(people(:henry_iv))
      expect(relationship_info[:lowest_common_ancestors]).to be(nil)
    end

    it "does not return lowest_common_ancestors for a direct ancestor" do
      relationship_info = people(:henry_iv).relationship_info(people(:edward_iii))
      expect(relationship_info[:lowest_common_ancestors]).to be(nil)
    end


    it "returns nil for unrelated people" do
      relationship_information = people(:catherine_of_valois).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq(nil)
    end

    it "returns '1st cousin' for a 1st cousin without removal" do
      relationship_information = people(:henry_iv).relationship_info(people(:richard_of_cambridge))
      expect(relationship_information[:relationship]).to eq("1st cousin")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to include("Philippa of Hainult", "Edward III")
    end

    it "works for cousins beyond 1st" do
      relationship_information = people(:henry_v).relationship_info(people(:richard_of_york))
      expect(relationship_information[:relationship]).to eq("2nd cousin")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to include("Philippa of Hainult", "Edward III")
    end

    it "works for removal" do
      relationship_information = people(:henry_vi).relationship_info(people(:richard_of_york))
      expect(relationship_information[:relationship]).to eq("2nd cousin once removed")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to include("Philippa of Hainult", "Edward III")
    end

    it "works for extreme removal" do
      relationship_information = people(:henry_vii).relationship_info(people(:richard_ii))
      expect(relationship_information[:relationship]).to eq("1st cousin 3 times removed")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to include("Philippa of Hainult", "Edward III")
    end

    it "works for half cousins" do
      relationship_information = people(:henry_v).relationship_info(people(:somerset))
      expect(relationship_information[:relationship]).to eq("half 1st cousin")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt")
    end

    it "works for a sister" do
      relationship_information = people(:john_beaufort).relationship_info(people(:joan_beaufort))
      expect(relationship_information[:relationship]).to eq("sister")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt", "Katherine Swynford")
    end

    it "works for a brother" do
      relationship_information = people(:joan_beaufort).relationship_info(people(:john_beaufort))
      expect(relationship_information[:relationship]).to eq("brother")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt", "Katherine Swynford")
    end

    it "works for a nephew" do
      relationship_information = people(:thomas_of_woodstock).relationship_info(people(:richard_ii))
      expect(relationship_information[:relationship]).to eq("nephew")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Philippa of Hainult", "Edward III")
    end

    it "works for a neice" do
      relationship_information = people(:john_beaufort).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("neice")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt", "Katherine Swynford")
    end

    it "works for an aunt" do
      relationship_information = people(:somerset).relationship_info(people(:joan_beaufort))
      expect(relationship_information[:relationship]).to eq("aunt")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt", "Katherine Swynford")
    end

    it "works for an uncle" do
      relationship_information = people(:edward_iv).relationship_info(people(:warwick))
      expect(relationship_information[:relationship]).to eq("uncle")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Ralph Neville", "Joan Beaufort")
    end

    it "works for a great plus auntcle" do
      relationship_information = people(:edward_iv).relationship_info(people(:lionel))
      expect(relationship_information[:relationship]).to eq("great-great-uncle")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Philippa of Hainult", "Edward III")
    end

    it "works for a great plus neicphew" do
      relationship_information = people(:lionel).relationship_info(people(:richard_of_york))
      expect(relationship_information[:relationship]).to eq("great-nephew")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Philippa of Hainult", "Edward III")
    end

    it "works for a father" do
      relationship_information = people(:edward_iv).relationship_info(people(:richard_of_york))
      expect(relationship_information[:relationship]).to eq("father")
    end

    it "works for a mother" do
      relationship_information = people(:edward_iv).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("mother")
    end

    it "works for a son" do
      relationship_information = people(:cecily_neville).relationship_info(people(:edward_iv))
      expect(relationship_information[:relationship]).to eq("son")
    end

    it "works for a daughter" do
      relationship_information = people(:ralph_neville).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("daughter")
    end

    it "works for a grandparent" do
      relationship_information = people(:edward_iv).relationship_info(people(:ralph_neville))
      expect(relationship_information[:relationship]).to eq("grandfather")
    end

    it "works for a grandchild" do
      relationship_information = people(:edward_iii).relationship_info(people(:richard_ii))
      expect(relationship_information[:relationship]).to eq("grandson")
    end

    it "works for extreme ancestor" do
      relationship_information = people(:edward_v).relationship_info(people(:joan_beaufort))
      expect(relationship_information[:relationship]).to eq("great-grandmother")
    end

    it "works for extreme descendant" do
      relationship_information = people(:edward_iii).relationship_info(people(:henry_vii))
      expect(relationship_information[:relationship]).to eq("great-great-great-grandson")
    end

    it "works for a son-in-law" do
      relationship_information = people(:somerset).relationship_info(people(:edmund_tudor))
      expect(relationship_information[:relationship]).to eq("son-in-law")
    end

    it "works for a daughter-in-law" do
      relationship_information = people(:richard_of_york).relationship_info(people(:elizabeth_woodville))
      expect(relationship_information[:relationship]).to eq("daughter-in-law")
    end

    it "works for a father-in-law" do
      relationship_information = people(:edmund_tudor).relationship_info(people(:somerset))
      expect(relationship_information[:relationship]).to eq("father-in-law")
    end

    it "works for a mother-in-law" do
      relationship_information = people(:elizabeth_woodville).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("mother-in-law")
    end

    it "works for a wife" do
      relationship_information = people(:edward_iv).relationship_info(people(:elizabeth_woodville))
      expect(relationship_information[:relationship]).to eq("wife")
    end

    it "works for a wife" do
      relationship_information = people(:edward_iv).relationship_info(people(:elizabeth_woodville))
      expect(relationship_information[:relationship]).to eq("wife")
    end

    it "works for a husband" do
      relationship_information = people(:margaret_beaufort).relationship_info(people(:edmund_tudor))
      expect(relationship_information[:relationship]).to eq("husband")
    end
    
    it "works for a brother-in-law (brother of a spouse)" do
      relationship_information = people(:elizabeth_woodville).relationship_info(people(:richard_iii))
      expect(relationship_information[:relationship]).to eq("brother-in-law")
    end

    it "works for a sister-in-law (sister of a spouse)" do
      relationship_information = people(:elizabeth_woodville).relationship_info(people(:margaret_of_york))
      expect(relationship_information[:relationship]).to eq("sister-in-law")
    end

    it "works for a brother-in-law (husband of a sibling)" do
      relationship_information = people(:john_beaufort).relationship_info(people(:ralph_neville))
      expect(relationship_information[:relationship]).to eq("brother-in-law")
    end

    it "works for a sister-in-law (wife of a brother)" do
      relationship_information = people(:richard_iii).relationship_info(people(:elizabeth_woodville))
      expect(relationship_information[:relationship]).to eq("sister-in-law")
    end
  end
end