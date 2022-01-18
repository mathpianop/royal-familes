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

  describe "#set_child_ids" do
    xit "sets the appropriate parent id attribute on each corresponsing child" do
      expect(people(:unconnected_male).father_id).to eq(nil)
      expect(people(:unconnected_female).father_id).to eq(nil)
      person1 = people(:unconnected_male)
      p person1.father_id
      person1.father_id = 23
      people(:thomas_of_woodstock).set_child_ids([people(:unconnected_male).id, people(:unconnected_female).id])
      p person1.father_id
      # people(:unconnected_female).save
      # people(:unconnected_male).save
      # people(:unconnected_female).reload
      # people(:unconnected_male).reload
      expect(people(:unconnected_male).father_id).to eq(people(:thomas_of_woodstock).id)
      expect(people(:unconnected_female).father_id).to eq(people(:thomas_of_woodstock).id)
    end

    it "removes existing parent connections for records not in ids list" do
      expect(people(:edward_v).father_id).to eq(people(:edward_iv).id)
      people(:edward_iv).set_child_ids([])
      people(:edward_v).reload
      expect(people(:edward_v).father_id).to eq(nil)
    end

    it "does not allow assignment for ineligble children" do
      person = people(:henry_vii)
      child = people(:edward_iii)
      person.set_child_ids([child.id])
      expect(person.errors[:parent][0]).to eq("can't be a descendant")
    end

    it "returns false if assignment triggers validation errors in children" do
      person = people(:henry_vii)
      child = people(:edward_iii)
      expect(person.set_child_ids([child.id])).to be(false)
    end
  end
end