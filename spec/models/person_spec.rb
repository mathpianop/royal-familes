require 'rails_helper'

RSpec.describe Person, type: :model do
  fixtures :people, :marriages

  describe "#confirm_no_children" do
    it "prevents destruction if person is a father" do
      people(:edward_iii).destroy
      expect(people(:edward_iii)).not_to be_destroyed
    end

    it "prevents destruction if person is a mother" do
      people(:philippa).destroy
      expect(people(:philippa)).not_to be_destroyed
    end

    it "allows destruction if person has no children" do
      people(:edward_v).destroy
      expect(people(:edward_v)).to be_destroyed
    end
  end

  describe "#children" do
    it "returns the children of the person" do
      expect(people(:edward_iii).children).to contain_exactly(
        people(:thomas_of_woodstock),
        people(:john_gaunt),
        people(:lionel),
        people(:black_prince),
        people(:edmund_of_york)
      )
    end
  end
  
  describe "#parents" do
    it "returns the parents of a person under the keys 'male' and 'female'" do
      expect(people(:edward_iv).parents).to eq({
        female: people(:cecily_neville),
        male: people(:richard_of_york)
    })
    end

    it "returns a nil value for a missing parent" do
      expect(people(:richard_of_cambridge).parents).to eq({
        female: nil,
        male: people(:edmund_of_york)
    })
    end

    it "returns nil values for two missing parents" do
      expect(people(:edward_iii).parents).to eq({male: nil, female: nil})
    end
  end

  describe "#grandparents" do
    it "returns the two pairs grandparents of a person under the keys 'maternal' and 'paternal'" do
      grandparents = people(:edward_iv).grandparents
      expect(people(:edward_iv).grandparents[:maternal]).to contain_exactly(
        people(:joan_beaufort),
        people(:ralph_neville)
      )
      expect(grandparents[:paternal]).to contain_exactly(
        people(:anne_mortimer),
        people(:richard_of_cambridge)
      )
    end

    it "works if grandparents are missing" do
      grandparents = people(:henry_iv).grandparents
      expect(grandparents[:maternal]).to eq([])
      expect(grandparents[:paternal]).to contain_exactly(
        people(:edward_iii),
        people(:philippa)
      )
    end

    it "returns empty arrays as values if no parents are specified" do
      grandparents = people(:edward_iii).grandparents
      expect(grandparents).to eq({maternal: [], paternal: []})
    end

    it "works if one parent is missing" do
      grandparents = people(:richard_of_cambridge).grandparents
      expect(grandparents[:maternal]).to eq([])
      expect(grandparents[:paternal]).to contain_exactly(
        people(:edward_iii),
        people(:philippa)
      )
    end
  end

  describe "#grandchildren" do
    it "returns a hash of grandchildren arrays with their parents' ids as keys" do
      grandchildren = people(:john_gaunt).grandchildren
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
        expect(people(:henry_v).siblings).to contain_exactly(
          people(:bedford), 
          people(:humphrey)
        )
      end

      it "returns an empty array if no siblings" do
        expect(people(:edward_iii).siblings).to eq([])
      end
    end

    describe "#family" do
      it "returns a hash with keys for parents, grandparents, children, grandchildren. spouses, and siblings" do
        expect(people(:richard_of_york).family).to eq({
          parents: people(:richard_of_york).parents,
          grandparents: people(:richard_of_york).grandparents,
          children: people(:richard_of_york).children,
          grandchildren: people(:richard_of_york).grandchildren,
          siblings: people(:richard_of_york).siblings,
          spouses: people(:richard_of_york).consorts
        })
      end
    end

  #Separate these guys out?

  describe "#relationship_info" do

    it "returns lowest_common_ancestors with name and id" do
      relationship_info = people(:john_gaunt).relationship_info(people(:black_prince))
      dad = relationship_info[:lowest_common_ancestors].find do |person| 
        person.name == "Edward III"
      end
    
      expect(dad.id).to eq(people(:edward_iii).id)
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
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Richard, Duke of York")
    end

    it "works for a mother" do
      relationship_information = people(:edward_iv).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("mother")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Cecily Neville")
    end

    it "works for a son" do
      relationship_information = people(:cecily_neville).relationship_info(people(:edward_iv))
      expect(relationship_information[:relationship]).to eq("son")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Cecily Neville")
    end

    it "works for a daughter" do
      relationship_information = people(:ralph_neville).relationship_info(people(:cecily_neville))
      expect(relationship_information[:relationship]).to eq("daughter")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Ralph Neville")
    end

    it "works for a grandparent" do
      relationship_information = people(:edward_iv).relationship_info(people(:ralph_neville))
      expect(relationship_information[:relationship]).to eq("grandfather")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Ralph Neville")
    end

    it "works for a grandchild" do
      relationship_information = people(:edward_iii).relationship_info(people(:richard_ii))
      expect(relationship_information[:relationship]).to eq("grandson")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Edward III")
    end

    it "works for extreme ancestor" do
      relationship_information = people(:edward_v).relationship_info(people(:joan_beaufort))
      expect(relationship_information[:relationship]).to eq("great-grandmother")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Joan Beaufort")
    end

    it "works for extreme descendant" do
      relationship_information = people(:edward_iii).relationship_info(people(:henry_vii))
      expect(relationship_information[:relationship]).to eq("great-great-great-grandson")
      expect(relationship_information[:lowest_common_ancestors].map(&:name)).to contain_exactly("Edward III")
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

  describe "#ancestors" do
    it "returns parents if no >=grandparents exist" do
      expect(people(:black_prince).ancestors).to contain_exactly(people(:edward_iii), people(:philippa))
    end

    it "returns all four grandparents if specified" do
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

    it "gives the ancestors in birth order" do
      expect(people(:richard_of_cambridge).ancestors).to eq([
        people(:edward_iii),
        people(:philippa),
        people(:edmund_of_york)
    ])
    end

    it "puts the ancestors without a specified birth date at the end" do
      expect(people(:richard_of_york).ancestors).to eq([
        people(:edward_iii),
        people(:philippa),
        people(:lionel),
        people(:edmund_of_york),
        people(:anne_mortimer),
        people(:philippa_of_clarence),
        people(:richard_of_cambridge),
        people(:roger_mortimer)
    ])
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
        people(:edward_v),
        people(:margaret_of_york)
      )
    end

    it "returns descendants beyond two generations" do
      expect(people(:richard_of_cambridge).descendants).to contain_exactly(
        people(:richard_of_york),
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york)
      )
    end

    it "returns an empty array for someone with no specified descendants" do
      expect(people(:richard_iii).descendants).to contain_exactly()
    end

    it "doesn't repeat descendants when cousins" do
      expect(people(:edward_iii).descendants).to contain_exactly(
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
      expect(people(:richard_of_york).descendants).to eq([
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york)
      ])
    end

    it "puts the descendants without specified birth_date at the end" do
      
      expect(people(:richard_of_cambridge).descendants).to eq([
        people(:edward_iv),
        people(:richard_iii),
        people(:edward_v),
        people(:margaret_of_york),
        people(:richard_of_york)
      ])
    end
  end
end