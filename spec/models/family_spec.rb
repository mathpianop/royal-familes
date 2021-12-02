require 'rails_helper'

RSpec.describe Person, type: :model do
  fixtures :people, :marriages


  describe "#children" do
    it "returns the children of the person" do
      expect(Family.new(people(:edward_iii)).children).to contain_exactly(
        people(:thomas_of_woodstock),
        people(:john_gaunt),
        people(:lionel),
        people(:black_prince),
        people(:edmund_of_york)
      )
    end

    it "returns an empty array for an unsaved record" do
      person = Person.new
      expect(Family.new(person).children).to eq([])
    end
  end
  
  describe "#parents" do
    it "returns the parents of a person under the keys 'male' and 'female'" do
      expect(Family.new(people(:edward_iv)).parents).to eq({
        female: people(:cecily_neville),
        male: people(:richard_of_york)
    })
    end

    it "returns a nil value for a missing parent" do
      expect(Family.new(people(:richard_of_cambridge)).parents).to eq({
        female: nil,
        male: people(:edmund_of_york)
    })
    end

    it "returns nil values for two missing parents" do
      expect(Family.new(people(:edward_iii)).parents).to eq({male: nil, female: nil})
    end
  end

  describe "#grandparents" do
    it "returns the two pairs grandparents of a person under the keys 'maternal' and 'paternal'" do
      grandparents = Family.new(people(:edward_iv)).grandparents
      expect(grandparents[:maternal]).to contain_exactly(
        people(:joan_beaufort),
        people(:ralph_neville)
      )
      expect(grandparents[:paternal]).to contain_exactly(
        people(:anne_mortimer),
        people(:richard_of_cambridge)
      )
    end

    it "returns the pairs with grandfather, then grandmother" do
      grandparents = Family.new(people(:edward_iv)).grandparents
      expect(grandparents[:maternal]).to eq([
        people(:ralph_neville),
        people(:joan_beaufort)
      ])
      expect(grandparents[:paternal]).to eq([
        people(:richard_of_cambridge),
        people(:anne_mortimer)
      ])
    end

    it "works if grandparents are missing" do
      grandparents = Family.new(people(:henry_iv)).grandparents
      expect(grandparents[:maternal]).to eq([])
      expect(grandparents[:paternal]).to contain_exactly(
        people(:edward_iii),
        people(:philippa)
      )
    end

    it "returns empty arrays as values if no parents are specified" do
      grandparents = Family.new(people(:edward_iii)).grandparents
      expect(grandparents).to eq({maternal: [], paternal: []})
    end

    it "works if one parent is missing" do
      grandparents = Family.new(people(:richard_of_cambridge)).grandparents
      expect(grandparents[:maternal]).to eq([])
      expect(grandparents[:paternal]).to contain_exactly(
        people(:edward_iii),
        people(:philippa)
      )
    end
  end

  describe "#grandchildren" do
    it "returns a hash of grandchildren arrays with their parents' ids as keys" do
      grandchildren = Family.new(people(:john_gaunt)).grandchildren
      expect(grandchildren[people(:henry_iv).id]).to contain_exactly(
        people(:henry_v), 
        people(:bedford), 
        people(:humphrey),
        people(:fake_guy)
      )
      expect(grandchildren[people(:john_beaufort).id]).to contain_exactly(
        people(:somerset)
      )
      expect(grandchildren[people(:joan_beaufort).id]).to contain_exactly(
        people(:warwick), 
        people(:cecily_neville)
      )
    end
  end

  describe "#siblings" do
    it "returns an array with all the siblings" do
      expect(Family.new(people(:henry_v)).siblings).to contain_exactly(
        people(:bedford), 
        people(:humphrey)
      )
    end

    it "returns an empty array if no siblings" do
      expect(Family.new(people(:edward_iii)).siblings).to eq([])
    end
  end


  describe "#ancestors" do
    it "returns parents if no >= grandparents exist" do
      expect(Family.new(people(:black_prince)).ancestors).to contain_exactly(people(:edward_iii), people(:philippa))
    end

    it "returns all four grandparents if specified" do
      expect(Family.new(people(:edward_iv)).ancestors).to include(
        people(:cecily_neville),
        people(:richard_of_york),
        people(:richard_of_cambridge),
        people(:anne_mortimer),
        people(:ralph_neville),
        people(:joan_beaufort)
      )
    end

    it "returns an ancestry which goes beyond two generations" do
      expect(Family.new(people(:edward_iv)).ancestors).to include(
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
      expect(Family.new(people(:edward_iii)).ancestors).to contain_exactly()
    end

    it "doesn't repeat ancestors for a child of cousins without removal" do
      expect(Family.new(people(:fake_guy)).ancestors).to contain_exactly(
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
      expect(Family.new(people(:edward_iv)).ancestors).to contain_exactly(
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

    it "gives the ancestors in birth order" do
      expect(Family.new(people(:richard_of_cambridge)).ancestors).to eq([
        people(:edward_iii),
        people(:philippa),
        people(:edmund_of_york)
    ])
    end
  end

  describe "#ancestors_without_parents" do
    it "gives the ancestors without the parents" do
      expect(Family.new(people(:fake_guy)).ancestors_without_parents).to contain_exactly(
        people(:lionel),
        people(:john_gaunt),
        people(:blanche_of_lancaster),
        people(:edward_iii),
        people(:philippa)
      )
    end
  end

  describe "#descendants" do
    it "returns children if there are no grandchildren" do
      expect(Family.new(people(:edward_iv)).descendants).to contain_exactly(people(:edward_v))
    end

    it "returns grandchildren if specified" do
      expect(Family.new(people(:richard_of_york)).descendants).to contain_exactly(
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york)
      )
    end

    it "returns descendants beyond two generations" do
      expect(Family.new(people(:richard_of_cambridge)).descendants).to contain_exactly(
        people(:richard_of_york),
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york)
      )
    end

    it "returns an empty array for someone with no specified descendants" do
      expect(Family.new(people(:richard_iii)).descendants).to contain_exactly()
    end

    it "doesn't repeat descendants when cousins" do
      expect(Family.new(people(:edward_iii)).descendants).to contain_exactly(
        people(:richard_of_york),
        people(:edward_iv),
        people(:margaret_of_york),
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

    it "gives the descendants in birth order" do
      expect(Family.new(people(:richard_of_york)).descendants).to eq([
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york)
      ])
    end    
  end
end