const ancestors = document.getElementById("ancestors");
const descendants = document.getElementById("descendants");

const ensureOnlyOneOpen = function(e) {
  if (e.target.id === "ancestors" && descendants.open) {
    descendants.open = false; 
  } else if(e.target === "descendants" && ancestors.open) {
    ancestors.open = false; 
  }
}

if (ancestors && descendants) {
  ancestors.addEventListener("toggle", ensureOnlyOneOpen);
  descendants.addEventListener("toggle", ensureOnlyOneOpen);
}