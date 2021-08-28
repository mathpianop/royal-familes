require 'rails_helper'

RSpec.describe Person, type: :model do
  fixtures :people

  describe "#relationship_info" do
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
      relationship_information = people(:joan_beaufort).relationship_info(people(:john_beaufort))
      expect(relationship_information[:relationship]).to eq("sister")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("John of Gaunt")
    end
  end

  describe "#ancestors" do
    it "returns parents if no >=grandparents exist" do
      expect(people(:black_prince).ancestors).to contain_exactly(people(:edward_iii), people(:philippa))
    end

    it "returns all four grandparents if specified specified" do
      expect(people(:edward_iv).ancestors).to include(
        people(:cecily_neville),
        people(:richard_of_york),
        people(:richard_of_cambridge),
        people(:anne_mortimer),
        people(:ralph_neville),
        people(:joan_beaufort)
      )
    end

    it "returns an ancestry which goes beyond two generations" do
      expect(people(:edward_iv).ancestors).to include(
        people(:cecily_neville),
        people(:richard_of_york),
        people(:richard_of_cambridge),
        people(:anne_mortimer),
        people(:ralph_neville),
        people(:joan_beaufort),
        people(:katherine_swynford),
        people(:john_gaunt),
        people(:roger_mortimer),
        people(:philippa_of_clarence),
        people(:lionel),
        people(:edmund_of_york),
        people(:philippa),
        people(:edward_iii)
      )
    end

    it "returns an empty array for someone with no specified ancestors" do
      expect(people(:edward_iii).ancestors).to contain_exactly()
    end

    it "doesn't repeat ancestors for a child of cousins without removal" do
      expect(people(:fake_guy).ancestors).to contain_exactly(
        people(:henry_iv),
        people(:philippa_of_clarence),
        people(:lionel),
        people(:john_gaunt),
        people(:blanche_of_lancaster),
        people(:edward_iii),
        people(:philippa)
      )
    end

    it "doesn't repeat ancestors for a child of cousins with removal" do
      expect(people(:edward_iv).ancestors).to contain_exactly(
        people(:cecily_neville),
        people(:richard_of_york),
        people(:richard_of_cambridge),
        people(:anne_mortimer),
        people(:ralph_neville),
        people(:joan_beaufort),
        people(:katherine_swynford),
        people(:john_gaunt),
        people(:roger_mortimer),
        people(:philippa_of_clarence),
        people(:lionel),
        people(:edmund_of_york),
        people(:philippa),
        people(:edward_iii)
      )
    end

    xit "gives the ancestors in birth order" do

    end
  end

  describe "#descendants" do
    it "returns children if there are no grandchildren" do
      expect(people(:edward_iv).descendants).to contain_exactly(people(:edward_v))
    end

    it "returns grandchildren if specified" do
      expect(people(:richard_of_york).descendants).to contain_exactly(
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v)
      )
    end

    it "returns descendants beyond two generations" do
      expect(people(:richard_of_cambridge).descendants).to contain_exactly(
        people(:richard_of_york),
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v)
      )
    end

    it "returns an empty array for someone with no specified descendants" do
      expect(people(:richard_iii).descendants).to contain_exactly()
    end

    it "doesn't repeat descendants when cousins" do
      expect(people(:edward_iii).descendants).to contain_exactly(
        people(:richard_of_york),
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:cecily_neville),
        people(:richard_of_cambridge),
        people(:anne_mortimer),
        people(:joan_beaufort),
        people(:john_gaunt),
        people(:roger_mortimer),
        people(:philippa_of_clarence),
        people(:fake_guy),
        people(:lionel),
        people(:edmund_of_york),
        people(:thomas_of_woodstock),
        people(:bedford),
        people(:humphrey),
        people(:henry_iv),
        people(:henry_v),
        people(:henry_vi),
        people(:margaret_beaufort),
        people(:somerset),
        people(:black_prince),
        people(:richard_ii),
        people(:john_beaufort),
        people(:henry_vii),
        people(:warwick)
      )
    end

    xit "gives the descendants in birth order" do

    end
  end
end