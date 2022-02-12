import getBirthdate from "./getWikipediaBirthdate";
import formatDate from "./formatDate";

const makeDateGuesses = function() {
  const nameField = document.getElementById("person_name");
  const titleField = document.getElementById("person_title");

  nameField.addEventListener("blur", () => {
    applyGuesses(nameField.value, titleField.value)
  })

  titleField.addEventListener("blur", () => {
    applyGuesses(nameField.value, titleField.value)
  })
}

const applyGuesses = function(name, title) {
  const birthdateField = document.getElementById("person_birth_date");

  getBirthdate(name, title).then(guess => {
    if (guess) {
      try {
        birthdateField.value = formatDate(guess);
      } catch (error) {
        if (error instanceof RangeError) {
          console.log(`Cannot format date guess: ${guess}`)
        } else {
          throw error
        }
      }
      
    }
  })
}

export {makeDateGuesses}

