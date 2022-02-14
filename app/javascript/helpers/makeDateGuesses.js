import getBirthdate from "./getWikipediaDates";
import formatDate from "./formatDate";
import getWikipediaDates from "./getWikipediaDates";

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

const applyGuessToDateField = function(dateType, guess) {
  const field = document.getElementById(`person_${dateType}_date`);
  if (guess) {
    try {
      field.value = formatDate(guess);
    } catch (error) {
      if (error instanceof RangeError) {
        console.log(`Cannot format date guess: ${guess}`)
      } else {
        throw error
      }
    }
  }
}

const applyGuesses = function(name, title) {
  const birthdateField = document.getElementById("person_birth_date");

  getWikipediaDates(name, title).then(dates => {
    applyGuessToDateField("birth", dates.getDate("birth"));
    applyGuessToDateField("death", dates.getDate("death"));
  })
}

export {makeDateGuesses}

