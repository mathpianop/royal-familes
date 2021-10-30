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
  placeholder: "Search relations...",
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

const buildAncestorListItem = function(name, id) {
  const listItemEl = document.createElement("LI");
  const anchorEl = document.createElement("A");
  anchorEl.textContent = name;
  anchorEl.href = `/people/${id}`;
  listItemEl.append(anchorEl)
  return listItemEl
}

const buildAncestorsList = function(ancestors) {
  const listEl = document.createElement("UL");
  listEl.append(buildAncestorListItem(ancestors[0].name, ancestors[0].id))
  if (ancestors.length > 1) {
    listEl.append(buildAncestorListItem(ancestors[1].name, ancestors[1].id))
  }
  return listEl
}

const buildAncestorsEl = function(ancestors) {
  const ancestorsEl = document.createElement("P");
  const ancestorHeader = document.createElement("H6");
  ancestorHeader.append("Lowest Common Ancestor");
  if (ancestors.length > 1) ancestorHeader.append("s");
  ancestorsEl.append(ancestorHeader);
  ancestorsEl.append(buildAncestorsList(ancestors));
  return ancestorsEl
}

const formatRelationshipInfo = function(relationshipInfo) {
  if (relationshipInfo["relationship"]) {
    return `${capitalize(relationshipInfo["relationship"])} to ${relationshipForm.dataset.name}`
  } else {
    return "There is no blood or simple in-law relationship with this person"
  } 
}

const buildRelationshipEl = function(relationshipInfo) {
  const relationshipEl = document.createElement("P")
  const relationshipHeader = document.createElement("H6");
  relationshipHeader.innerText = "Relationship" 
  relationshipEl.append(relationshipHeader)
  relationshipEl.append(formatRelationshipInfo(relationshipInfo));
  return relationshipEl
}


const displayRelationshipInfo = function(relationshipInfo) {
  const relationshipInfoEl = document.getElementById("relationship-info");
  //Clear out the info element
  relationshipInfoEl.textContent = "";
  //Attach the relationship statement (e.g., Relationship: Son)
  relationshipInfoEl.appendChild(buildRelationshipEl(relationshipInfo))
  //If applicable, attach lowest common ancestor statement
  if (relationshipInfo["lowest_common_ancestors"]) {
    const ancestorsEl = buildAncestorsEl(relationshipInfo["lowest_common_ancestors"])
    relationshipInfoEl.appendChild(ancestorsEl)
  }
}