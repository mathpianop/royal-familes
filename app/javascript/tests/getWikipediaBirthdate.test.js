import getBirthdate from "../helpers/getWikipediaBirthdate";

describe("getBirthdate", () => {
  it("works when the name matches WP article", () => {
    return getBirthdate("Elizabeth I", "Queen of England").then((date) => {
      expect(date).toBe("7 September 1533");
    })
  })

  it("works when the name and the title are required to match a title", () => {
    return getBirthdate("John", "King of England").then((date) => {
      expect(date).toBe("24 December 1166");
    })
  })

  it("works when the name and the title are required to match a title", () => {
    return getBirthdate("John", "King of England").then((date) => {
      expect(date).toBe("24 December 1166");
    })
  })

  it("returns falsy when no article can be chosen from query", () => {
    return getBirthdate("Maxish", "the Greatish").then((date) => {
      expect(date).toBeFalsy();
    })
  })

  it("returns falsy when an article is chosen, but no infobox is present", () => {
    return getBirthdate("athlete", "").then((date) => {
      expect(date).toBeFalsy();
    })
  })

  it("returns falsy when an infobox is present, but without a birth_date field", () => {
    return getBirthdate("Asian Games", "").then((date) => {
      expect(date).toBeFalsy();
    })
  })
});
