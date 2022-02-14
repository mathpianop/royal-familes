import getWikipediaDates from "../helpers/getWikipediaDates";

describe("getWikipediaDates", () => {
  it("works when the name matches WP article", () => {
    return getWikipediaDates("Elizabeth I", "Queen of England").then((dates) => {
      expect(dates.getDate("birth")).toBe("7 September 1533");
    })
  })

  it("works when the name and the title are required to match a title", () => {
    return getWikipediaDates("John", "King of England").then((dates) => {
      expect(dates.getDate("birth")).toBe("24 December 1166");
    })
  })

  it("works when the name and the title are required to match a title", () => {
    return getWikipediaDates("John", "King of England").then((dates) => {
      expect(dates.getDate("birth")).toBe("24 December 1166");
    })
  })

  it("returns falsy when no article can be chosen from query", () => {
    return getWikipediaDates("Maxish", "the Greatish").then((dates) => {
      expect(dates.getDate("birth")).toBeFalsy();
    })
  })

  it("returns falsy when an article is chosen, but no infobox is present", () => {
    return getWikipediaDates("athlete", "").then((dates) => {
      expect(dates.getDate("birth")).toBeFalsy();
    })
  })

  it("returns falsy when an infobox is present, but without a birth_date field", () => {
    return getWikipediaDates("Asian Games", "").then((dates) => {
      expect(dates.getDate("birth")).toBeFalsy();
    })
  })

  it("works for death date", () => {
    return getWikipediaDates("Elizabeth I", "Queen of England").then((dates) => {
      expect(dates.getDate("death")).toBe("24 March 1603");
    })
  })
});
