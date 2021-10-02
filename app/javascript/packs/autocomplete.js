import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic/dist/theme.css';
import "styles/custom-autocomplete.css";

const formatSuggestion = function(person) {
  return (person["title"] ? `${person["name"]}, ${person["title"]}` : person["name"])
}
const suggestions = JSON.parse(document.getElementById('father-search').dataset.suggestions)


autocomplete({
  container: '#father-search',
  placeholder: 'Search for father...',
  getSources({ query, setQuery }) {
    return [
      {
        sourceId: "people",
        getItems() {
          const text = query.toLowerCase();
          const people = suggestions;
          const matches = [];
          for (let i = 0; i < people.length; i++) {
              if (~people[i]["name"].toLowerCase().indexOf(text)) {
                matches.push(people[i])
              };
            }
          return matches
        },
        templates: {
          item({ item }) {
            const itemButton = document.createElement("BUTTON")
            itemButton.textContent = formatSuggestion(item)
            itemButton.addEventListener("click", () => {
              console.log("Hello")
              setQuery(formatSuggestion(item))
            })
            return formatSuggestion(item)
          }
        }
      }
    ]
    
    
  },
});



// const autocompleteSearch = function() {
//   const suggestions = JSON.parse(document.getElementById('father-search-data').dataset.suggestions)
//   const input = document.getElementById('q');
  
//   if (suggestions && input) {
//     autocomplete({
//       selector: input,
//       source: function(text, update) {
//           text = text.toLowerCase();
//           const people = suggestions;
//           const matches = [];
//           for (let i = 0; i < people.length; i++) {
//               if (~people[i]["name"].toLowerCase().indexOf(text)) {
//                 matches.push(formatSuggestion(people[i]))
//               };
//             }
//             console.log(matches)
//           update(matches);
//       },
//     });
//   }
// };

// const fatherSearchData = document.getElementById('father-search-data')
// fatherSearchData.addEventListener("keydown", autocompleteSearch)