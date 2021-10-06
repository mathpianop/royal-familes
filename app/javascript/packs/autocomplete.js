// import { autocomplete } from '@algolia/autocomplete-js';
// import { html } from 'htm/preact';
// import '@algolia/autocomplete-theme-classic/dist/theme.css';
// import "styles/custom-autocomplete.css";



const suggestions = JSON.parse(document.getElementById('father-search').dataset.suggestions)

const formatSuggestion = function(person) {
  return (person["title"] ? `${person["name"]}, ${person["title"]}` : person["name"])
}

const input = document.getElementById("q");
input.addEventListener("keyup", (e) => {
  showMatches(e.target.value)
})

const filterMatches = function(query, possiblePeople) {
  const text = query.toLowerCase();
  console.log(possiblePeople)
  return possiblePeople.filter(possiblePerson => {
    ~possiblePerson["name"].toLowerCase().indexOf(text)
  })
}

const showMatches = function(query) {
  console.log("Hello")
  results = document.getElementById("results");
  results.innerHTML = '';
  let list = '';
  let terms = filterMatches(query, suggestions);
  console.log(terms)
  for (i=0; i<terms.length; i++) {
    list += '<li>' + terms[i] + '</li>';
  }
  results.innerHTML = '<ul>' + list + '</ul>';
}






// autocomplete({
//   container: '#father-search',
//   placeholder: 'Search for father...',
//   debug: true,
//   getSources({ query, setQuery, setIsOpen}) {
//     const selectItem = function(item) {
//       setQuery(formatSuggestion(item)); 
//       setIsOpen(false);
//     }

//     const handleEnter = function(event) {
//       if (event.key === "Enter") {
//         console.log("Yay")
//       }
//     }

//     const input = document.getElementsByClassName("aa-Input")[0]
//     input.addEventListener("keyup", handleEnter)
//     console.log("Yes")

//     return [
//       {
//         sourceId: "people",
//         getItems() {
//           const text = query.toLowerCase();
//           const people = suggestions;
//           const matches = [];
//           for (let i = 0; i < people.length; i++) {
//               if (~people[i]["name"].toLowerCase().indexOf(text)) {
//                 matches.push(people[i])
//               };
//             }
//           return matches
//         },
//         templates: {
//           item({ item }) {
//             const handleItemClick = function() {
//               selectItem(item)
//             }

           
//             return html`
//               <div onClick=${handleItemClick} onKeyUp=${handleEnter}>
//                 ${formatSuggestion(item)}
//               </div>
//           `}
//         }
//       }
//     ]
    
    
//   },
// });
