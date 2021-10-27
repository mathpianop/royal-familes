import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";
import axios from "axios";


const relationSearch = document.getElementById("relation-search");
const relationIdField = document.getElementById("relation-id");
const relationshipForm = document.getElementById("relationship-form");

const getRelationship = function(subjectId) {
  const relationId = relationIdField.value;
  if (relationId) {
    axios.get(`/relationship/${subjectId}/${relationId}`).then(response => {
      console.log(response.data)
      displayRelationshipInfo(response.data)
    })
  }
}

relationshipForm.addEventListener("submit", (e) => {
  e.preventDefault();
  getRelationship(e.target.dataset.id)
})


searchPeople({
  container: relationSearch,
  placeholder: "Search for a relation...",
  onSelect: (selection) => {
    setPersonInfo("relation-id", selection.id);
    getRelationship(relationshipForm.dataset.id);
  },
  onClear: () => clearPersonInfo("relation-id"),
  personIdField: relationIdField
})

const capitalize = function(string) {
  return string[0].toUpperCase() + string.slice(1)
}

const buildAncestorAnchor = function(name, id) {
  const anchorEl = document.createElement("A");
  anchorEl.textContent = name;
  anchorEl.href = `/people/${id}`;
  return anchorEl
}

const buildAncestorsEl = function(ancestors) {
  const ancestorsEl = document.createElement("P")
  ancestorsEl.append("Lowest Common Ancestor");
  ancestors.length > 1 ? ancestorsEl.append("s: ") : ancestorsEl.append(": ")
  ancestorsEl.append(buildAncestorAnchor(ancestors[0].name, ancestors[0].id))
  if (ancestors.length > 1) {
    ancestorsEl.append(", ")
    ancestorsEl.append(buildAncestorAnchor(ancestors[1].name, ancestors[1].id))
  }
  console.log(ancestorsEl);
  return ancestorsEl
}

const formatRelationshipInfo = function(relationshipInfo) {
  if (relationshipInfo["relationship"]) {
    return `${capitalize(relationshipInfo["relationship"])} to ${relationshipForm.dataset.name}`
  } else {
    return "There is no blood relationship or simple in-law relationship between these two people"
  } 
}


const displayRelationshipInfo = function(relationshipInfo) {
  const relationshipInfoEl = document.getElementById("relationship-info");
  //Clear out the info element
  relationshipInfoEl.textContent = "";
  //Attach the relationship statement (e.g., Relationship: Son)
  const relationshipEl = document.createElement("P")
  relationshipEl.innerText = formatRelationshipInfo(relationshipInfo)
  relationshipInfoEl.appendChild(relationshipEl)
  //If applicable, attach lowest common ancestor statement
  if (relationshipInfo["lowest_common_ancestors"]) {
    const ancestorsEl = buildAncestorsEl(relationshipInfo["lowest_common_ancestors"])
    relationshipInfoEl.appendChild(ancestorsEl)
  }
}