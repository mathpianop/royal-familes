class Family
  def initialize(person)
    @children = person.children
    @spouses = person.spouses
    @grandchildren = person.grandchildren
    @parents = person.parents
    @grandparents = @person.grandparents
  end
end