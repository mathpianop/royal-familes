import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";

const personSearch = document.getElementsByClassName("person-search")[0];
console.log(personSearch)

searchPeople({
  container: personSearch,
  placeholder: "Search people...",
  onSelect: (selection) => {
    location.href = `/people/${selection.id}`
  }
})