import { searchPeople, setPersonInfo, clearPersonInfo } from "../helpers/autocompleteHelper";

const personSearch = document.getElementById("person-search");
console.log(personSearch)

searchPeople({
  container: personSearch,
  placeholder: "Search people...",
  onSelect: (selection) => {
    location.href = `/people/${selection.id}`
  }
})