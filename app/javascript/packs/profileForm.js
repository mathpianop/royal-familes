import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";

const fatherSearch = document.getElementById("father-search");
const fatherIdField = document.getElementById("person_father_id")
const motherSearch = document.getElementById("mother-search");
const motherIdField = document.getElementById("person_mother_id");
const spousesFieldset = document.getElementById("spouses-fields");
const getSpouseForms = function() {
  return spousesFieldset.getElementsByClassName("spouse-form");
}

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


//This could be a separate object??

const attachSpouseAutocomplete = function(spouseForm) {
  const spouseIdField = spouseForm.querySelector('input[type=hidden]');
  searchPeople({
    container: spouseForm, 
    placeholder: "Search For Spouse...", 
    //Figure this out later
    // sex: ???,
    onSelect: (selection) => setPersonInfo(spouseIdField.id, selection.id),
    onClear: () => clearPersonInfo(spouseIdField.id),
    personIdField: spouseIdField
  });
}




const buildSpouseFormElement = function() {
  const listElement = document.createElement("LI");
  listElement.classList.add("spouse-form", "autocomplete-container");
  const inputElement = document.createElement("INPUT");
  inputElement.type = "hidden";
  const spouseIndex = getSpouseForms().length;
  inputElement.name = `person[consorts_attributes][${spouseIndex}][id]`;
  inputElement.id = `person_consorts_attributes_${spouseIndex}_id`;
  listElement.appendChild(inputElement);
  const cancelBtn = buildCancelBtn(listElement);
  listElement.appendChild(cancelBtn);
  return listElement
}
const attachCancelBtn = function(spouseForm) {
  const cancelBtn = buildCancelBtn(spouseForm);
  spouseForm.appendChild(cancelBtn);
}

const buildCancelBtn = function(spouseForm) {
  const btn = document.createElement("BUTTON")
  btn.type = "button";
  btn.textContent = "Cancel Spouse";
  btn.class = "cancel-spouse-btn"
  btn.addEventListener("click", () => {
    spouseForm.remove();
  });
  return btn;
}


Array.from(getSpouseForms()).forEach((spouseForm) => {
  attachCancelBtn(spouseForm);
  attachSpouseAutocomplete(spouseForm);
})

const addSpouseBtn = document.getElementById("add-spouse");

addSpouseBtn.addEventListener("click", () => {
  const spouseForm = buildSpouseFormElement();
  spousesFieldset.querySelector("ul").appendChild(spouseForm);
  attachSpouseAutocomplete(spouseForm);
})