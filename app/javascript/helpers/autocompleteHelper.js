//import autocomplete from "autocomplete-select";
import autocomplete from "../../../../autocomplete-select";
//import "autocomplete-select/autocomplete.css";
import "../../../../autocomplete-select/autocomplete.css"
import axios from "axios";

function setPersonInfo (inputElId, value) {
  const inputEl = document.getElementById(inputElId);
  inputEl.value = value
}

function clearPersonInfo (inputElId) {
  const inputEl = document.getElementById(inputElId);
  inputEl.value = "";
}

function searchPeople({ container, placeholder, sex, onSelect, onClear, personIdField }) {

  const confirmedOnClear = (onClear ? onClear : () => {});
  const getPeople = (query, display) => {
    axios.get("/autocomplete", { params: {
        query: query.toLowerCase(),
        sex: sex
      }
    }).then(response => {
      display(response.data.people)
    })
  }

  const formatNameAndTitle = (name, title) => {
    return (title ? `${name}, ${title}` : name)
  }
  
  const formatPerson = (person) => {
    return formatNameAndTitle(person["name"], person["title"])
  }

  let initialValue;
  
  if (personIdField) {
    initialValue = formatNameAndTitle(
      personIdField.dataset.name, 
      personIdField.dataset.title
    )
  }

  
  autocomplete({
    container: container,
    onInput: getPeople,
    formatMatch: formatPerson,
    placeholder: placeholder,
    onSelect: onSelect,
    clearBtn: true,
    onClear: confirmedOnClear,
    initialValue: initialValue
  })
}

export { searchPeople, setPersonInfo, clearPersonInfo };






