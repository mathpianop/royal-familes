const grandparentsList = document.querySelector(".grandparents-level")
const parentsList = document.querySelector(".parents-level")

const onlyMaternalGrandparents = function() {
  return (
    grandparentsList &&
    grandparentsList.querySelector(".maternal-grandparents") &&
    !grandparentsList.querySelector(".paternal-grandparents")
  )
}

const grandparentsWithOnlyOneParent = function() {
  console.log(parentsList.querySelectorAll(".parents a").length);
  return (
    grandparentsList &&
    parentsList &&
    parentsList.querySelectorAll(".parents a").length === 1
  )
}

if (onlyMaternalGrandparents()) {
  grandparentsList.classList.add("only-maternal")
}

if (grandparentsWithOnlyOneParent()) {
  grandparentsList.classList.add("grandparents-single-parent")
}
