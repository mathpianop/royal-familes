import autocomplete from "./helpers/autocomplete"
import axios from "axios";



function searchPeople({ container, placeholder, sex }) {

  const setPersonInfo = function(selectedPerson) {
    
  }

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
    onSelect: setPersonInfo,
    clearBtn: true,
    onClear: () => console.log("Delete")
  })
}

export default searchPeople;






