const grandparentsList = document.querySelector(".grandparents-level")
const parentsList = document.querySelector(".parents-level")

import wtf from "wtf_wikipedia";
function getBirthdate(name, title) {
  wtf.fetch(name).then((doc) => {
    if (doc.infobox()) {
      console.log(doc.infobox());
      return doc.infobox()
    }
  })
}
getBirthdate("Elizabeth I", "Queen of England");
const onlyMaternalGrandparents = function() {
  return (
    grandparentsList &&
    grandparentsList.querySelector(".maternal-grandparents") &&
    !grandparentsList.querySelector(".paternal-grandparents")
  )
}

const onlyPaternalGrandparents = function() {
  return (
    grandparentsList &&
    !grandparentsList.querySelector(".maternal-grandparents") &&
    grandparentsList.querySelector(".paternal-grandparents")
  )
}

const grandparentsWithOnlyOneParent = function() {
  if (parentsList) {
    return (
      grandparentsList &&
      parentsList &&
      parentsList.querySelectorAll(".parents-node a").length === 1
    )
  }
}

const grandparentsOnOnlyOneSide = function() {
  return (
    grandparentsList &&
    grandparentsList.querySelectorAll("li").length === 1
  )
}





if (grandparentsWithOnlyOneParent()) {
  grandparentsList.classList.add("grandparents-single-parent")
} else if (onlyMaternalGrandparents()) {
  grandparentsList.classList.add("only-maternal")
} else if (onlyPaternalGrandparents()) {
  grandparentsList.classList.add("only-paternal")
}




