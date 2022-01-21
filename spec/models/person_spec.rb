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

  describe "set_consort_ids" do
    it "creates  new marriage records for a single id included" do
      husband = people(:black_prince)
      wife = people(:joan_of_kent)
      husband.set_consort_ids([wife.id])
      expect(Marriage.where(person_id: husband.id, consort_id: wife.id)[0]).to be_truthy
    end

    it "creates new marriage records for multiple ids included" do
      husband = people(:black_prince)
      wife1 = people(:joan_of_kent)
      wife2 = people(:unconnected_female)
      husband.set_consort_ids([wife1.id, wife2.id])
      expect(Marriage.where(person_id: husband.id, consort_id: wife1.id)[0]).to be_truthy
      expect(Marriage.where(person_id: husband.id, consort_id: wife2.id)[0]).to be_truthy
    end

    it "does not create new marriage records for ids corresponding existing records" do
      husband = people(:edward_iv)
      wife = people(:elizabeth_woodville)
      husband.set_consort_ids([wife.id])
      expect(Marriage.where(person_id: husband.id, consort_id: wife.id).length).to eq(1)
    end

    it "deletes marriage records with ids not in the list" do
      husband = people(:edward_iv)
      new_wife = people(:unconnected_female)
      old_wife = people(:elizabeth_woodville)
      husband.set_consort_ids([new_wife.id])
      expect(Marriage.where(person_id: husband.id, consort_id: old_wife.id).length).to eq(0) 
    end

    it "deletes all marriage records when passed an empty array" do
      husband = people(:edward_iv)
      husband.set_consort_ids([])
      expect(Marriage.where(person_id: husband.id).length).to eq(0) 
    end

    it "Adds marriage validation errors to the person" do
      husband = people(:edward_iv)
      ancestor = people(:philippa)
      
      #expect(husband.set_consort_ids([ancestor.id])).to be(false)
      husband.set_consort_ids([ancestor.id])
      expect(Marriage.where(person_id: husband.id, consort_id: ancestor.id).length).to eq(0) 
    end
  end
end