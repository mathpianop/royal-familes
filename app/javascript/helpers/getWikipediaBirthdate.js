
import parser from "wtf_wikipedia";

const getBirthdate = function(name, title) {
  return getInfobox(name, title).then(infobox => {
    if (infobox && infobox.get("birth_date")) {
      return infobox.get("birth_date").text();
    }
  })
}

const getInfobox = function(name, title) {
  //If a page is found with the name alone, then use that
  //Otherwise, use the name and title together
  return getPageFromName(name).then(page => {
    if (page.infobox()) {
      return page.infobox();
    } else {
      return getPageFromNameAndTitle(name, title).then(page => {
        if (page.infobox()) {
          return page.infobox();
        }
      })
    }
  })
}

const getPageFromName = function(name) {
  return parser.fetch(name);
}

const getPageFromNameAndTitle = function(name, title) {
  return parser.fetch(`${name}, ${title}`);
}


export {getBirthdate}



