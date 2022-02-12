import formatDate from "../helpers/formatDate";
import { parse } from "date-fns";

describe("formatDate", () => {
  it("takes a Wikipedia-format date string and returns a browser-format date string", () => {
    expect(formatDate("14 September 2021")).toBe("2021-09-14");
  })

  it("works when the Wikipedia date is format is LLLL dd, yyyy", () => {
    expect(formatDate("September 14, 2021")).toBe("2021-09-14");
  })
})