// import { autocomplete } from '@algolia/autocomplete-js';
// import { html } from 'htm/preact';
// import '@algolia/autocomplete-theme-classic/dist/theme.css';
import "styles/autocomplete.css";



//Abstract
const sources = JSON.parse(document.getElementById('father-search').dataset.suggestions)

//Abstract
const input = document.getElementById("q");
input.addEventListener("keyup", (e) => {
  showMatches(e.target.value)
})

//Abstract
const filterSources = function(query, sources) {
  const text = query.toLowerCase();
  return sources.filter(source => {
    return ~source["name"].toLowerCase().indexOf(text)
  }).map(formatMatch)
}

//Abstract
const formatMatch = function(person) {
  return (person["title"] ? `${person["name"]}, ${person["title"]}` : person["name"])
}

let matches
let matchNodes;
let activeMatchId;

const markActive = function(matchEl) {
  activeMatchId = matchEl.dataset.matchIndex;
  //Fill the input with the text of the match
  input.value = matchNodes[activeMatchId].innerText;
  matchEl.classList.add("active")
}

const markInactive = function(matchEl) {
  matchEl.classList.remove("active")
}

const createMatchNodes = function(matches) {
  return matches.map((match, index) => {
    const item = document.createElement("LI");
    item.dataset.matchIndex = index;
    item.addEventListener("mouseenter", e => markActive(e.target));
    item.addEventListener("mouseleave", e => markInactive(e.target));
    typeof match === "string" ? item.textContent = match : item.appendChild(match);
    return item;
  })
}

document.addEventListener("click", () => {
  const resultsPanels = document.getElementsByClassName("results");
  Array.from(resultsPanels).forEach(panel => panel.remove())
})





const showMatches = function(query) {
  matches = filterSources(query, sources);
  matchNodes = createMatchNodes(matches)
  const list = matchNodes.reduce((listParent, matchNode) => {
    listParent.appendChild(matchNode)
    return listParent
  }, document.createElement("UL"))
  const results = getResultsPanel()
  results.textContent = "";
  results.appendChild(list);
}


const getResultsPanel = function() {
  //If results panel exists, return it. Otherwise, create it.
  const inputSibling = input.nextElementSibling
  console.log(inputSibling)
  if (inputSibling && inputSibling.classList.contains("results")) {
    return inputSibling
  } else {
    return createResultsPanel()
  }
}

const createResultsPanel = function() {
  const resultsPanel = document.createElement("DIV")
  resultsPanel.classList.add("results")
  input.insertAdjacentElement("afterend", resultsPanel)
  return resultsPanel
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
