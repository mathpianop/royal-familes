import parser from "wtf_wikipedia";

function PageNotFoundException(name, title) {
  this.name = name;
  this.title = title;
  this.message = `Page with name: ${name} and title: ${title} could not be found`;
}

function Dates() {
  const dates = {};

  //Sanitize out anything in parentheses
  //e.g., "24 March 1603 (aged 69) => 24 March 1603"
  this.addDate = (dateType, date) => dates[dateType] = date.replace(/ *\([^)]*\) */g, "");
  this.getDate = (dateType) => dates[dateType]
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

const getWikipediaDates = function(name, title) {
  return getInfobox(name, title).then(infobox => {
    const dates = new Dates();
    //If available, add birth and death dates to the dates object
    ["birth", "death"].forEach((dateType) => {
      if (infobox.get(`${dateType}_date`)) {
         dates.addDate(dateType, infobox.get(`${dateType}_date`).text());
      }  
    })
    
    return dates;
  }).catch((error) => {
    if (error instanceof PageNotFoundException) {
      return new Dates();
    } else {
      throw error
    }
  })
}

export default getWikipediaDates;