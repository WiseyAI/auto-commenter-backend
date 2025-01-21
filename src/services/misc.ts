export function cleanUpAuthorName(text: string) {
  if (!text) {
    return "";
  }
  const regex = /^(.+?)(?:'s\s*Post|Post)/;
  const match = text.match(regex);
  const name = match ? match[1].trim().replace(/'s$/, "") : "";
  return name;
}
