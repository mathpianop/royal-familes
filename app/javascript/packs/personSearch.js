import { searchPeople} from "../helpers/autocompleteHelper";

const personSearch = document.getElementsByClassName("person-search")[0];
const personSearchForm = document.getElementById("person-search-form");
console.log(personSearch)

searchPeople({
  container: personSearch,
  placeholder: "Search people...",
  name: "person_search[query]",
  onSelect: (selection) => {
    if (selection) {
      location.href = `/people/${selection.id}`
    }
  }
})