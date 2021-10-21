const grandparentsList = document.querySelector(".ascent-tree ul")

const onlyMaternalGrandparents = function() {
  return (
    grandparentsList &&
    grandparentsList.querySelector(".maternal-grandparents") &&
    !grandparentsList.querySelector(".paternal-grandparents")
  )
}

if (onlyMaternalGrandparents()) {
  grandparentsList.style.justifyContent = "flex-end"
}
