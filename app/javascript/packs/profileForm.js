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

const oppositeSex = function(sex) {
  return (sex === "F" ? "M" : "F")
}


//This could be a separate object??

const attachSpouseAutocomplete = function(spouseForm) {
  const spouseIdField = spouseForm.querySelector('input[type=hidden]');
  const container = spouseForm.querySelector(".autocomplete-container")
  searchPeople({
    container: container, 
    placeholder: "Search For Spouse...", 
    sex: oppositeSex(spousesFieldset.dataset.personSex),
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
  const cancelBtn = buildCancelBtn(listElement);
  const autocompleteContainer = document.createElement("DIV");
  autocompleteContainer.classList.add("autocomplete-container");
  listElement.append(inputElement, autocompleteContainer, cancelBtn)
  return listElement
}
const attachCancelBtn = function(spouseForm) {
  const cancelBtn = buildCancelBtn(spouseForm);
  spouseForm.appendChild(cancelBtn);
}

const buildCancelBtn = function(spouseForm) {
  const btn = document.createElement("BUTTON")
  btn.type = "button";
  btn.textContent = "Remove";
  btn.classList.add("cancel-spouse-btn");
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

const wrapSpouseForm = function(spouseForm) {
  const formUnitWrapper = document.createElement("DIV");
  formUnitWrapper.classList.add("form-unit");
  const formLineWrapper = document.createElement("DIV");
  formLineWrapper.classList.add("form-line")
  formLineWrapper.appendChild(spouseForm);
  formUnitWrapper.appendChild(formLineWrapper);
  return formUnitWrapper;
}

const addSpouse = function() {
  const spouseForm = buildSpouseFormElement();
  spousesFieldset.querySelector("ul").appendChild(wrapSpouseForm(spouseForm));
  attachSpouseAutocomplete(spouseForm);
}
addSpouseBtn.addEventListener("click", addSpouse);

