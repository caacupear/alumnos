const DICTIONARY_FOLDER = process.cwd() + "/docs/diccionarios/objects";
const WORKING_FOLDER = process.env.INIT_CWD || ".";
const DEFAULT_INTRO = "intro";
const fs = require("fs");

function sortByLabel(objA, objB) {
  return objA.label > objB.label ? 1 : objA.label < objB.label ? -1 : 0;
}

function getContextCache(fileName) {
  const fullName = WORKING_FOLDER + "/" + fileName;
  if (!fs.existsSync(fullName)) {
    throw new Error(
      `No existe el archivo ${fullName}. Debe ser un json generado por el flag -o`
    );
  }
  const content = fs.readFileSync(fullName);
  try {
    return JSON.parse(content).objects;
  } catch {
    throw new Error(
      "Archivo invalido: el  ${fileName} debe ser un json generado por el flag -o"
    );
  }
}

module.exports = {
  DICTIONARY_FOLDER,
  WORKING_FOLDER,
  DEFAULT_INTRO,
  sortByLabel,
  getContextCache
};
