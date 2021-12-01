import { searchPeople, setPersonInfo, clearPersonInfo } from "./autocompleteHelper";

const manageDynamicRelationForm = function(relationType, placeholder, sex) {

  const relationFieldset = document.getElementById(`${relationType}-fields`);

  const getRelationForms = function() {
    return relationFieldset.getElementsByClassName("relation-form");
  }

  let indexOfLastField = getRelationForms().length - 1;

  const attachAutocomplete = function(formlet) {
    const idField = formlet.querySelector('input[type=hidden]');
    const container = formlet.querySelector(".autocomplete-container")
    searchPeople({
      container: container, 
      placeholder: placeholder, //param 
      sex: sex, //param
      onSelect: (selection) => setPersonInfo(idField.id, selection.id),
      onClear: () => clearPersonInfo(idField.id),
      personIdField: idField
    });
  }
  
 

  const buildFormElement = function() {
    const listElement = document.createElement("LI");
    listElement.classList.add("relation-form");
    const inputElement = document.createElement("INPUT");
    inputElement.type = "hidden";
    const relationIndex = ++indexOfLastField;
    inputElement.name = `person[${relationType}][][id]`;
    inputElement.id = `person_${relationType}_${relationIndex}_id`;
    const cancelBtn = buildCancelBtn(listElement);
    const autocompleteContainer = document.createElement("DIV");
    autocompleteContainer.classList.add("autocomplete-container");
    listElement.append(inputElement, autocompleteContainer, cancelBtn)
    return listElement
  }
  const attachCancelBtn = function(relationForm) {
    const cancelBtn = buildCancelBtn(relationForm);
    relationForm.appendChild(cancelBtn);
  }
  
  const buildCancelBtn = function(relationForm) {
    const btn = document.createElement("BUTTON")
    btn.type = "button";
    btn.textContent = "Remove";
    btn.classList.add("cancel-relation-btn");
    btn.addEventListener("click", () => {
      relationForm.remove();
    });
    return btn;
  }
  const wrapRelationForm = function(relationForm) {
    const formUnitWrapper = document.createElement("DIV");
    formUnitWrapper.classList.add("field");
    const formLineWrapper = document.createElement("DIV");
    formLineWrapper.classList.add("form-line")
    formLineWrapper.appendChild(relationForm);
    formUnitWrapper.appendChild(formLineWrapper);
    return formUnitWrapper;
  }
  
  const addRelation = function() {
    const relationForm = buildFormElement();
    relationFieldset.querySelector("ul").appendChild(wrapRelationForm(relationForm));
    attachAutocomplete(relationForm);
  }

  Array.from(getRelationForms()).forEach((relationForm) => {
    attachCancelBtn(relationForm);
    attachAutocomplete(relationForm);
  })
  
  const addRelationBtns = relationFieldset.getElementsByClassName("add-relation");

  addRelationBtns[0].addEventListener("click", addRelation);

}

export {manageDynamicRelationForm};
