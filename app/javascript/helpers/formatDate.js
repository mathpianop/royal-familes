import parse from "date-fns/parse";
import format from "date-fns/format";

//Convert date from Wikipedia format to browser field format
const formatDate = function(dateString) {
  let date; 
  let formattedDate;
  try {
    //Try parsing one format
    date = parse(dateString, "dd LLLL y", new Date());
    formattedDate = format(date, "yyyy-LL-dd")
  } catch(e) {
    //If that throws a RangeError, try parsing a different
    if (e instanceof RangeError) {
      date = parse(dateString, "LLLL dd, yyyy", new Date());
      formattedDate = format(date, "yyyy-LL-dd");
    } else {
      throw e;
    }
  }
  return formattedDate;
}

export default formatDate;