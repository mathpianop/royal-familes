import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";

const fatherSearch = document.getElementById("father-search");
const motherSearch = document.getElementById("mother-search");



searchPeople({
  container: fatherSearch,
  placeholder: "Search For Father...", 
  sex: "M",
  onSelect: (selection) => setPersonInfo("person_father_id", selection.id),
  onClear: () => clearPersonInfo("person_father_id")
});

searchPeople({
  container: motherSearch, 
  placeholder: "Search For Mother...", 
  sex: "F",
  onSelect: (selection) => setPersonInfo("person_mother_id", selection.id),
  onClear: () => clearPersonInfo("person_mother_id")
});

