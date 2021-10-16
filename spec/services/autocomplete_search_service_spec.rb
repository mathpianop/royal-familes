require 'rails_helper'

RSpec.describe AutocompleteSearchService, type: :service do
  fixtures :people, :marriages
  describe "#call" do
    it "returns results that match query" do
      results = AutocompleteSearchService.new("ed").call[:people]
      expect(results).to include(
        people(:edward_iv),
        people(:edmund_tudor),
        people(:edward_iii),
        people(:edward_v),
        people(:edmund_of_york)
      )
    end

    it "filters results based on :sex option" do
      results = AutocompleteSearchService.new("e").call[:people]
      expect(results).to include(people(:edward_iv), people(:elizabeth_woodville)
      )

      results = AutocompleteSearchService.new("e", sex: "M").call[:people]
      expect(results).to include(people(:edward_iv))
      expect(results).to_not include(people(:elizabeth_woodville))
    end
  end
end