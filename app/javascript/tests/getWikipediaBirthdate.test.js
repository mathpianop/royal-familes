import { getBirthdate } from "../helpers/getWikipediaBirthdate";

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
});
