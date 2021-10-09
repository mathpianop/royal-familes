import autocomplete from "../helpers/autocomplete"

const container = document.getElementById("father-search");
const sources = JSON.parse(document.getElementById('father-search').dataset.suggestions)


const getPeople = function(query) {
  const text = query.toLowerCase();
  return sources.filter(source => {
    return ~source["name"].toLowerCase().indexOf(text)
  })
}

const formatPerson = function(person) {
  return (person["title"] ? `${person["name"]}, ${person["title"]}` : person["name"])
}

autocomplete({
  container: container,
  getMatches: getPeople,
  formatMatch: formatPerson,
  placeholder: "Search for Father",
  onSelect: (item) => console.log(item),
  clearBtn: true,
  onClear: () => console.log("Delete")
})