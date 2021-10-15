import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";

const fatherSearch = document.getElementById("father-search");
const fatherIdField = document.getElementById("person_father_id")
const motherSearch = document.getElementById("mother-search");
const motherIdField = document.getElementById("person_mother_id")


searchPeople({
  container: fatherSearch,
  placeholder: "Search For Father...", 
  sex: "M",
  onSelect: (selection) => setPersonInfo("person_father_id", selection.id),
  onClear: () => clearPersonInfo("person_father_id"),
  personIdField: fatherIdField
});

searchPeople({
  container: motherSearch, 
  placeholder: "Search For Mother...", 
  sex: "F",
  onSelect: (selection) => setPersonInfo("person_mother_id", selection.id),
  onClear: () => clearPersonInfo("person_mother_id"),
  personIdField: motherIdField
});

