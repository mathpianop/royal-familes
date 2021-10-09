import searchPeople from "searchPeople";

const fatherSearch = document.getElementById("father-search");
const motherSearch = document.getElementById("mother-search");

searchPeople({
  container: fatherSearch,
  placeholder: "Search For Father...", 
  sex: "M"
});

searchPeople({
  container: motherSearch, 
  placeholder: "Search For Mother...", 
  sex: "F"
});

