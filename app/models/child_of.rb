class ChildOf
  include ActiveGraph::Relationship

  from_class :Person
  to_class :Person
  type :CHILD
end