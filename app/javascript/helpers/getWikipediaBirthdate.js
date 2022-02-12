
import parser from "wtf_wikipedia";

function PageNotFoundException(name, title) {
  this.name = name;
  this.title = title;
  this.message = `Page with name: ${name} and title: ${title} could not be found`;
}

const getInfobox = function(name, title) {
  //If a page is found with the name alone, then use that.
  //Otherwise, use the name and title together
  return getPageFromName(name).then(page => {
    if (page && page.infobox()) {
      return page.infobox();
    } else {
      return getPageFromNameAndTitle(name, title).then(page => {
        if (page && page.infobox()) {
          return page.infobox();
        } else {
          throw new PageNotFoundException(name, title)
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

const getBirthdate = function(name, title) {
  return getInfobox(name, title).then(infobox => {
    if (infobox && infobox.get("birth_date")) {
      return infobox.get("birth_date").text();
    }
  }).catch((error) => {
    if (error instanceof PageNotFoundException) {
      return null;
    } else {
      throw error
    }
    
  })
}


export default getBirthdate;



