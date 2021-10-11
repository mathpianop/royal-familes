import autocomplete from "./autocomplete"
import axios from "axios";

function setPersonInfo (inputElId, value) {
  const inputEl = document.getElementById(inputElId);
  inputEl.value = value

}

function clearPersonInfo (inputElId) {
  const inputEl = document.getElementById(inputElId);
  inputEl.value = "";
}

function searchPeople({ container, placeholder, sex, onSelect, onClear }) {


  const getPeople = function(query, display) {
    axios.get("/autocomplete", { params: {
        query: query.toLowerCase(),
        sex: sex
      }
    }).then(response => {
      display(response.data.people)
    })
  }
  
  const formatPerson = function(person) {
    return (person["title"] ? `${person["name"]}, ${person["title"]}` : person["name"])
  }
  
  autocomplete({
    container: container,
    onInput: getPeople,
    formatMatch: formatPerson,
    placeholder: placeholder,
    onSelect: onSelect,
    clearBtn: true,
    onClear: onClear
  })
}

export { searchPeople, setPersonInfo, clearPersonInfo };






