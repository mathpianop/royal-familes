require 'rails_helper'

RSpec.describe SearchService, type: :service do
  fixtures :people, :marriages
  describe "#call" do
    it "returns results that match query" do
      results = SearchService.new("ed").call[:people]
      expect(results).to include(
        people(:edward_iv),
        people(:edmund_tudor),
        people(:edward_iii),
        people(:edward_v),
        people(:edmund_of_york)
      )
    end

    it "filters results based on :sex option" do
      results = SearchService.new("e").call[:people]
      expect(results).to include(people(:edward_iv), people(:elizabeth_woodville)
      )

      results = SearchService.new("e", sex: "M").call[:people]
      expect(results).to include(people(:edward_iv))
      expect(results).to_not include(people(:elizabeth_woodville))
    end
  end
end